//
//  RYSTIntroViewController.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmationLabel.h"
#import "RYSTIntroViewController.h"
#import "RYSTVideoViewController.h"
#import "UIView+RJDConvenience.h"

static const NSInteger kNumberOfOnboardingScreens = 3;
// this represents our decision of when the user should rotate between screens
static const CGFloat kOverlapForRotation = 100.0f;

@interface RYSTIntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) NSInteger currentScreenIndex; // index 0 is start

@end

@implementation RYSTIntroViewController

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

  // create the screens in reverse order
  UIView *screen1 = [[UIView alloc] initWithFrame:screenFrame];
  screen1.backgroundColor = [UIColor colorWithRed:(235.0/255.0) green:(46.0/255.0) blue:(81.0/255.0) alpha:1.0];
  [_scrollView addSubview:screen1];
  screenFrame.origin.y += CGRectGetHeight(self.view.bounds);

  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  titleLabel.textColor = [UIColor whiteColor];
  titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:45.0f];
  titleLabel.text = NSLocalizedString(@"Tap to begin!", nil); // need not localize as title is ubiquitous
  [screen1 addSubview:titleLabel];
  [screen1 centerChildren:@[titleLabel]];

  UIButton *overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(screen1.bounds), CGRectGetWidth(screen1.bounds))];
  [overlayButton addTarget:self action:@selector(begin) forControlEvents:UIControlEventTouchUpInside];
  [screen1 addSubview:overlayButton];

  UIView *screen4 = [[UIView alloc] initWithFrame:screenFrame];
  screen4.backgroundColor = [UIColor colorWithRed:63.0f/255.0f green:225.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
  [_scrollView addSubview:screen4];
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

  UIImageView *upArrow4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up-arrow"]];
  upArrow4.translatesAutoresizingMaskIntoConstraints = NO;

  [screen4 addSubview:explanationLabel];
  [screen4 addSubview:explanationLabel2];
  [screen4 addSubview:upArrow4];
  [screen4 centerChildren:@[explanationLabel2]];
  [screen4 centerChildrenHorizontally:@[upArrow4, explanationLabel]];

  [screen4 convenientConstraintsWithVisualFormats:@[ @"V:[upArrow]-50-|",
                                                     @"V:[explanationLabel]-25-[explanationLabel2]" ]
                                          options:0
                                          metrics:nil
                                         children:@{ @"upArrow" : upArrow4,
                                                     @"explanationLabel" : explanationLabel,
                                                     @"explanationLabel2" : explanationLabel2 }];

  UIView *screen5 = [[UIView alloc] initWithFrame:screenFrame];
  screen5.backgroundColor = [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  [_scrollView addSubview:screen5];
  screenFrame.origin.y += CGRectGetHeight(self.view.bounds);

  RYSTAffirmationLabel *positiveLabel = [[RYSTAffirmationLabel alloc] init];
  positiveLabel.translatesAutoresizingMaskIntoConstraints = NO;
  positiveLabel.text = NSLocalizedString(@"STAY POSITIVE!", nil);
  positiveLabel.textAlignment = NSTextAlignmentCenter;
  [screen5 addSubview:positiveLabel];
  [screen5 centerChildren:@[positiveLabel]];

  UIImageView *upArrow5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up-arrow"]];
  upArrow5.translatesAutoresizingMaskIntoConstraints = NO;
  [screen5 addSubview:upArrow5];
  [screen5 centerChildrenHorizontally:@[upArrow5]];
  [screen5 convenientConstraintsWithVisualFormats:@[ @"V:[upArrow]-50-|",
                                                     @"V:[positiveLabel(70)]",
                                                     @"H:[positiveLabel(240)]" ]
                                          options:0
                                          metrics:nil
                                         children:@{ @"upArrow" : upArrow5,
                                                     @"positiveLabel" : positiveLabel }];

  _scrollView.contentOffset = CGPointMake(0, (kNumberOfOnboardingScreens - 1) * CGRectGetHeight(self.view.bounds));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  self.view.userInteractionEnabled = NO;

  // if the user throws the screen with a gesture, just go whichever direction they wanted
  // otherwise, we use the overlap to decide where to take them
  if (velocity.y != 0) {
    if (velocity.y > 0 && self.currentScreenIndex > 0) {
      self.currentScreenIndex--;
    } else if (velocity.y < 0 && self.currentScreenIndex < kNumberOfOnboardingScreens - 1) {
      self.currentScreenIndex++;
    }
    NSInteger multiplier = kNumberOfOnboardingScreens - self.currentScreenIndex - 1;
    targetContentOffset->y = multiplier * CGRectGetHeight(self.view.bounds);
  } else {
    NSInteger multiplier = kNumberOfOnboardingScreens - self.currentScreenIndex - 1;
    CGFloat baseOffset = multiplier * CGRectGetHeight(self.view.bounds);
    if (scrollView.contentOffset.y - baseOffset < -kOverlapForRotation && self.currentScreenIndex < kNumberOfOnboardingScreens - 1) {
      self.currentScreenIndex++;
    } else if (scrollView.contentOffset.y - baseOffset > kOverlapForRotation && self.currentScreenIndex > 0) {
      self.currentScreenIndex--;
    }

    multiplier = kNumberOfOnboardingScreens - self.currentScreenIndex - 1;
    [scrollView setContentOffset:CGPointMake(0, multiplier * CGRectGetHeight(self.view.bounds)) animated:YES];
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
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  self.view.userInteractionEnabled = YES;
}

- (void)begin
{
  [self.presenter dismissChild:self];
}

@end
