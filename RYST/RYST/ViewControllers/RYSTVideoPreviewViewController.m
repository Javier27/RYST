//
//  RYSTVideoPreviewViewController.m
//  RYST
//
//  Created by Richie Davis on 4/20/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTVideoPreviewViewController.h"
#import "RYSTVideoViewController.h"
#import "RYSTAffirmationLabel.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RYSTVideoPreviewViewController ()

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, copy) NSString *affirmationText;

@end

@implementation RYSTVideoPreviewViewController

- (instancetype)initWithURL:(NSURL *)URL affirmationText:(NSString *)affirmation;
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _videoURL = URL;
    _affirmationText = affirmation;
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.previewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.previewImageView];
  [self generateImage];

  UILabel *submitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 80, CGRectGetWidth(self.view.bounds), 80)];
  submitLabel.backgroundColor = [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  submitLabel.textColor = [UIColor whiteColor];
  submitLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:25.0f];
  submitLabel.textAlignment = NSTextAlignmentCenter;
  submitLabel.text = NSLocalizedString(@"Swipe to Share >", nil);
  submitLabel.userInteractionEnabled = YES;
  [self.view addSubview:submitLabel];

  UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(saveVideo)];
  swipe.direction = UISwipeGestureRecognizerDirectionRight;
  swipe.numberOfTouchesRequired = 1;
  [submitLabel addGestureRecognizer:swipe];

  UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  [deleteButton setTitle:@"X" forState:UIControlStateNormal];
  [deleteButton setTitleColor:[UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f]
                     forState:UIControlStateNormal];
  deleteButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:19.0f];
  [deleteButton addTarget:self action:@selector(cancelVideo) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:deleteButton];

  RYSTAffirmationLabel *affirmation = [[RYSTAffirmationLabel alloc] initWithFrame:CGRectMake(0, 0, 210, 80)];
  affirmation.text = self.affirmationText;
  affirmation.center = self.view.center;
  affirmation.rectColor = [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  [self.view addSubview:affirmation];
}

-(void)generateImage
{
  AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
  AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  CMTime time = [asset duration];
  time.value = 300;
  CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
  UIImage *thumbnail = [[UIImage alloc] initWithCGImage:imageRef
                                                  scale:1.0
                                            orientation:UIImageOrientationRight];
  CGImageRelease(imageRef);

  self.previewImageView.image = thumbnail;
}

- (void)saveVideo
{
  [self.presenter dismissPreviewShouldSave:YES];
}

- (void)cancelVideo
{
  [self.presenter dismissPreviewShouldSave:NO];
}

@end
