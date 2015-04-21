//
//  RYSTVideoViewController.m
//  RYST
//
//  Created by Richie Davis on 4/20/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmationLabel.h"
#import "RYSTVideoViewController.h"
#import "UIView+RJDConvenience.h"

#import "RYSTLoadAndRepeatViewController.h"
#import "RYSTVideoPreviewViewController.h"

#import "RYSTRecordButton.h"

#import "RYSTAffirmation.h"
#import "RYSTCameraView.h"
#import "RYSTUploadResponse.h"
#import "RYSTVideoViewController.h"

#import "UIView+RJDConvenience.h"
#import "UILabel+FSHighlightAnimationAdditions.h"

#import "RYSTAffirmationScrollView.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

// this represents our decision of when the user should rotate between screens
static const CGFloat kOverlapForRotation = 100.0f;
static const NSInteger kNumberOfOnboardingScreens = 3;

static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface RYSTVideoViewController () <UIScrollViewDelegate, AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) NSInteger currentScreenIndex; // index 0 is start

@property (nonatomic, strong) UIViewController *previewChild;
@property (nonatomic, strong) UIViewController *saveChild;
@property (nonatomic, strong) RYSTAffirmationScrollView *affirmationScrollView;

@property (nonatomic) BOOL shouldDisplayIntro;
@property (nonatomic) BOOL shouldExplainView;
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) RYSTCameraView *previewView;
@property (nonatomic, strong) RYSTRecordButton *recordButton;
@property (nonatomic, strong) UIButton *flipCameraButton;

@property (nonatomic, strong) RYSTAffirmation *affirmation;

// recording session management
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

// utilities
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;

@property (nonatomic) BOOL isObserver;
@property (nonatomic) BOOL shouldDismissPreview;

@property (nonatomic, copy) NSArray *affirmations;
@property (nonatomic) BOOL errorOccurred;

@end

@implementation RYSTVideoViewController

- (BOOL)isSessionRunningAndDeviceAuthorized
{
  return [[self session] isRunning] && [self isDeviceAuthorized];
}

+ (NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
  return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.backgroundColor = [UIColor whiteColor];
  _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
  _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds),
                                       CGRectGetHeight(self.view.bounds) * kNumberOfOnboardingScreens);
  _scrollView.delegate = self;
  [self.view addSubview:_scrollView];

  _currentScreenIndex = 0;

  CGRect screenFrame = _scrollView.frame;

  UIView *screen1 = [[UIView alloc] initWithFrame:screenFrame];
  screen1.backgroundColor = [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  [_scrollView addSubview:screen1];
  screenFrame.origin.y += CGRectGetHeight(self.view.bounds);

  RYSTAffirmationLabel *positiveLabel = [[RYSTAffirmationLabel alloc] init];
  positiveLabel.translatesAutoresizingMaskIntoConstraints = NO;
  positiveLabel.text = NSLocalizedString(@"STAY POSITIVE!", nil);
  positiveLabel.rectColor = [UIColor whiteColor];
  positiveLabel.textAlignment = NSTextAlignmentCenter;
  [screen1 addSubview:positiveLabel];
  [screen1 centerChildren:@[positiveLabel]];

  UIImageView *upArrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up-arrow"]];
  upArrow1.translatesAutoresizingMaskIntoConstraints = NO;
  [screen1 addSubview:upArrow1];
  [screen1 centerChildrenHorizontally:@[upArrow1]];
  [screen1 convenientConstraintsWithVisualFormats:@[ @"V:[upArrow]-50-|",
                                                     @"V:[positiveLabel(80)]",
                                                     @"H:[positiveLabel(210)]" ]
                                          options:0
                                          metrics:nil
                                         children:@{ @"upArrow" : upArrow1,
                                                     @"positiveLabel" : positiveLabel }];

  UIView *screen2 = [[UIView alloc] initWithFrame:screenFrame];
  screen2.backgroundColor = [UIColor colorWithRed:63.0f/255.0f green:225.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
  [_scrollView addSubview:screen2];
  screenFrame.origin.y += CGRectGetHeight(self.view.bounds);

  UILabel *explanationLabel = [[UILabel alloc] init];
  explanationLabel.translatesAutoresizingMaskIntoConstraints = NO;
  explanationLabel.textColor = [UIColor whiteColor];
  explanationLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:22.0f];
  explanationLabel.text = NSLocalizedString(@"Record yourself\nsaying a positive\naffirmation you see.", nil);
  explanationLabel.numberOfLines = 0;
  explanationLabel.textAlignment = NSTextAlignmentCenter;

  UILabel *explanationLabel2 = [[UILabel alloc] init];
  explanationLabel2.translatesAutoresizingMaskIntoConstraints = NO;
  explanationLabel2.textColor = [UIColor whiteColor];
  explanationLabel2.font = [UIFont fontWithName:@"Avenir-Roman" size:22.0f];
  explanationLabel2.text = NSLocalizedString(@"Then, share it.", nil);
  explanationLabel2.numberOfLines = 0;
  explanationLabel2.textAlignment = NSTextAlignmentCenter;

  UIImageView *upArrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up-arrow"]];
  upArrow2.translatesAutoresizingMaskIntoConstraints = NO;

  [screen2 addSubview:explanationLabel];
  [screen2 addSubview:explanationLabel2];
  [screen2 addSubview:upArrow2];
  [screen2 centerChildren:@[explanationLabel2]];
  [screen2 centerChildrenHorizontally:@[upArrow2, explanationLabel]];

  [screen2 convenientConstraintsWithVisualFormats:@[ @"V:[upArrow]-50-|",
                                                     @"V:[explanationLabel]-25-[explanationLabel2]" ]
                                          options:0
                                          metrics:nil
                                         children:@{ @"upArrow" : upArrow2,
                                                     @"explanationLabel" : explanationLabel,
                                                     @"explanationLabel2" : explanationLabel2 }];

  _previewView = [[RYSTCameraView alloc] initWithFrame:screenFrame];
  [self.scrollView addSubview:_previewView];

  _recordButton = [[RYSTRecordButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
  [_recordButton addTarget:self action:@selector(toggleMovieRecording) forControlEvents:UIControlEventTouchUpInside];
  _recordButton.center = CGPointMake(self.view.center.x, CGRectGetHeight(self.view.frame) - 80);
  [self.previewView addSubview:_recordButton];

  // Create the AVCaptureSession
  AVCaptureSession *session = [[AVCaptureSession alloc] init];
  self.session = session;

  // Setup the preview view
  self.previewView.session = session;

  // Check for device authorization
  [self checkDeviceAuthorizationStatus];

  dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
  [self setSessionQueue:sessionQueue];

  dispatch_async(sessionQueue, ^{
    [self setBackgroundRecordingID:UIBackgroundTaskInvalid];

    NSError *error = nil;

    AVCaptureDevice *videoDevice = [RYSTVideoViewController deviceWithMediaType:AVMediaTypeVideo
                                                             preferringPosition:AVCaptureDevicePositionBack];
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];

    if (error) NSLog(@"%@", error);

    if ([session canAddInput:videoDeviceInput]) {
      [session addInput:videoDeviceInput];
      [self setVideoDeviceInput:videoDeviceInput];

      dispatch_async(dispatch_get_main_queue(), ^{
        [[(AVCaptureVideoPreviewLayer *)self.previewView.layer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
      });
    }

    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];

    if (error) NSLog(@"%@", error);

    if ([session canAddInput:audioDeviceInput]) [session addInput:audioDeviceInput];

    AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([session canAddOutput:movieFileOutput]) {
      [session addOutput:movieFileOutput];
      AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
      if ([connection isVideoStabilizationSupported]) connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
      [self setMovieFileOutput:movieFileOutput];
    }
  });

  self.isObserver = NO;
  self.shouldDismissPreview = NO;
  self.errorOccurred = NO;

  [self.apiClient getAffirmations:@10 completion:^(NSArray *result, NSError *error) {
    if (result) {
      self.affirmations = result;
      self.affirmationScrollView = [[RYSTAffirmationScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 80)
                                                                       affirmations:self.affirmations];
      self.affirmationScrollView.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    } else {
      self.errorOccurred = YES;
    }
  }];

  _scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self showCameraView];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  dispatch_async([self sessionQueue], ^{
    [[self session] stopRunning];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
    [[NSNotificationCenter defaultCenter] removeObserver:[self runtimeErrorHandlingObserver]];

    if (self.isObserver) {
      [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
      [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
      self.isObserver = NO;
    }
  });
}

- (void)dealloc
{
  if (self.isObserver) {
    [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
    [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:RecordingContext];
    self.isObserver = NO;
  }
}

- (void)showCameraView
{
  dispatch_async([self sessionQueue], ^{
    if (!self.isObserver) {
      [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
      [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
      self.isObserver = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];

    __weak typeof(self) weakSelf = self;
    [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
      typeof(self) strongSelf = weakSelf;
      dispatch_async([strongSelf sessionQueue], ^{
        // Manually restarting the session since it must have been stopped due to an error.
        [[strongSelf session] startRunning];
      });
    }]];
    [[self session] startRunning];
    [self changeCamera];
  });
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskPortrait;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == RecordingContext) {
    BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];

    dispatch_async(dispatch_get_main_queue(), ^{
      if (isRecording) {
        [self.flipCameraButton setEnabled:NO];
        [self.recordButton setEnabled:YES];
      } else {
        [self.flipCameraButton setEnabled:YES];
        [self.recordButton setEnabled:YES];
      }
    });
  } else if (context == SessionRunningAndDeviceAuthorizedContext) {
    BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];

    dispatch_async(dispatch_get_main_queue(), ^{
      if (isRunning) {
        [self.flipCameraButton setEnabled:YES];
        [self.recordButton setEnabled:YES];
      } else {
        [self.flipCameraButton setEnabled:NO];
        [self.recordButton setEnabled:NO];
      }
    });
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark Actions

- (void)toggleMovieRecording
{
  if (true) {
    [self.recordButton toggleRecording];

    [self.recordButton setEnabled:NO];

    dispatch_async([self sessionQueue], ^{
      if (![self.movieFileOutput isRecording]) {
        [self setLockInterfaceRotation:YES];

        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
          [self setBackgroundRecordingID:[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil]];
        }

        // Update the orientation on the movie file output video connection before starting recording.
        [[self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)self.previewView.layer connection] videoOrientation]];

        // Turning OFF flash for video recording
        [RYSTVideoViewController setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoDeviceInput] device]];

        // Start recording to a temporary file.
        NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
        [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
      } else {
        [self.movieFileOutput stopRecording];
      }
    });
  }
}

- (void)changeCamera
{
  dispatch_async([self sessionQueue], ^{
    AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
    AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
    AVCaptureDevicePosition currentPosition = [currentVideoDevice position];

    switch (currentPosition) {
      case AVCaptureDevicePositionUnspecified:
        preferredPosition = AVCaptureDevicePositionFront;
        break;
      case AVCaptureDevicePositionBack:
        preferredPosition = AVCaptureDevicePositionFront;
        break;
      case AVCaptureDevicePositionFront:
        preferredPosition = AVCaptureDevicePositionFront;
        break;
    }

    AVCaptureDevice *videoDevice = [RYSTVideoViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];

    [[self session] beginConfiguration];

    [[self session] removeInput:[self videoDeviceInput]];
    if ([[self session] canAddInput:videoDeviceInput]) {
      [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];

      [RYSTVideoViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];

      [[self session] addInput:videoDeviceInput];
      [self setVideoDeviceInput:videoDeviceInput];
    } else {
      [[self session] addInput:[self videoDeviceInput]];
    }

    [[self session] commitConfiguration];

    dispatch_async(dispatch_get_main_queue(), ^{
      [self.flipCameraButton setEnabled:YES];
      [self.recordButton setEnabled:YES];
    });
  });
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
  CGPoint devicePoint = CGPointMake(.5, .5);
  [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

#pragma mark File Output Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
  if (error) NSLog(@"%@", error);
  [self setLockInterfaceRotation:NO];
  self.videoURL = outputFileURL;
  [self presentPreview];
}

#pragma mark Device Configuration

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
  dispatch_async([self sessionQueue], ^{
    AVCaptureDevice *device = [[self videoDeviceInput] device];
    NSError *error = nil;
    if ([device lockForConfiguration:&error]) {
      if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
        [device setFocusMode:focusMode];
        [device setFocusPointOfInterest:point];
      }
      if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
        [device setExposureMode:exposureMode];
        [device setExposurePointOfInterest:point];
      }
      [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
      [device unlockForConfiguration];
    } else {
      NSLog(@"%@", error);
    }
  });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
  if ([device hasFlash] && [device isFlashModeSupported:flashMode]) {
    NSError *error = nil;
    if ([device lockForConfiguration:&error]) {
      [device setFlashMode:flashMode];
      [device unlockForConfiguration];
    } else {
      NSLog(@"%@", error);
    }
  }
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
  AVCaptureDevice *captureDevice = [devices firstObject];

  for (AVCaptureDevice *device in devices) {
    if ([device position] == position) return device;
  }

  return captureDevice;
}

#pragma mark UI

- (void)checkDeviceAuthorizationStatus
{
  NSString *mediaType = AVMediaTypeVideo;

  [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
    if (granted) {
      [self setDeviceAuthorized:YES];
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Oh No!"
                                    message:@"RYST needs to access your camera to share your positivity, please update your camera settings."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        [self setDeviceAuthorized:NO];
      });
    }}];
}

#pragma mark UIScrollViewMethods

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  self.view.userInteractionEnabled = NO;

  // if the user throws the screen with a gesture, just go whichever direction they wanted
  // otherwise, we use the overlap to decide where to take them
  if (velocity.y != 0) {
    if (velocity.y > 0 && self.currentScreenIndex < kNumberOfOnboardingScreens - 1) {
      self.currentScreenIndex++;
    } else if (velocity.y < 0 && self.currentScreenIndex > 0) {
      self.currentScreenIndex--;
    }

    targetContentOffset->y = self.currentScreenIndex * CGRectGetHeight(self.view.bounds);
  } else {
    CGFloat baseOffset = self.currentScreenIndex * CGRectGetHeight(self.view.bounds);
    if (scrollView.contentOffset.y - baseOffset > kOverlapForRotation && self.currentScreenIndex > 0) {
      self.currentScreenIndex++;
    } else if (scrollView.contentOffset.y - baseOffset < -kOverlapForRotation && self.currentScreenIndex < kNumberOfOnboardingScreens - 1) {
      self.currentScreenIndex--;
    }

    [scrollView setContentOffset:CGPointMake(0, self.currentScreenIndex * CGRectGetHeight(self.view.bounds)) animated:YES];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  self.view.userInteractionEnabled = NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  self.view.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  self.view.userInteractionEnabled = YES;
  if (self.currentScreenIndex == 2) [self updateAfterIntro];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  self.view.userInteractionEnabled = YES;
  if (self.currentScreenIndex == 2) [self updateAfterIntro];
}

#pragma mark action methods

- (void)updateAfterIntro
{
  [self.scrollView removeFromSuperview];
  self.previewView.frame = self.view.bounds;
  [self.view addSubview:self.previewView];

  [self.previewView addSubview:self.affirmationScrollView];

  if (self.errorOccurred) {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry!", nil)
                                message:NSLocalizedString(@"Looks like we're having difficulties loading the affirmations, come back and try again later.", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                      otherButtonTitles:nil, nil] show];
  }
}

- (void)presentPreview
{
  NSString *affirmationText = [self.affirmationScrollView currentAffirmation];
  RYSTVideoPreviewViewController *vc = [[RYSTVideoPreviewViewController alloc] initWithURL:self.videoURL
                                                                           affirmationText:affirmationText];
  vc.presenter = self;
  self.previewChild = vc;
  [self presentChild:vc];
}

- (void)presentChild:(UIViewController *)child
{
  [self addChildViewController:child];
  [self.view addSubview:child.view];
  [child didMoveToParentViewController:self];
  CGFloat height = CGRectGetHeight(self.view.bounds);
  CGFloat width = CGRectGetWidth(self.view.bounds);
  child.view.frame = CGRectMake(0, height, width, height);
  [UIView animateWithDuration:0.3f
                   animations:^{
                     child.view.frame = CGRectMake(0, 0, width, height);
                   } completion:^(BOOL finished) {
                     if (self.shouldDismissPreview) {
                       self.shouldDismissPreview = NO;
                       [self dismissChild:self.previewChild];
                       self.previewChild = nil;
                     }
                   }];
}

- (void)dismissChild:(UIViewController *)child
{
  CGFloat height = CGRectGetHeight(self.view.bounds);
  CGFloat width = CGRectGetWidth(self.view.bounds);
  [UIView animateWithDuration:0.3f
                   animations:^{
                     child.view.frame = CGRectMake(0, height, width, height);
                   } completion:^(BOOL finished) {
                     [child willMoveToParentViewController:nil];
                     [child.view removeFromSuperview];
                     [child removeFromParentViewController];
                     [self showCameraView];
                   }];
}

- (void)dismissPreviewShouldSave:(BOOL)shouldSave
{
  if (shouldSave) {
    self.shouldDismissPreview = YES;
    [self saveVideo];
  } else {
    self.videoURL = nil;
    [self dismissChild:self.previewChild];
    self.previewChild = nil;
  }
}

- (void)saveVideo
{
  // completion should remove the other VC
  RYSTLoadAndRepeatViewController *vc = [[RYSTLoadAndRepeatViewController alloc] initWithURL:self.videoURL];
  vc.presenter = self;
  self.saveChild = vc;
  [self presentChild:vc];
}

- (void)dismissAndRepeat
{
  [self dismissChild:self.saveChild];
  self.saveChild = nil;
}

@end
