//
//  RYSTSaveVideoViewController.m
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTSaveVideoViewController.h"
#import "RYSTVideoViewController.h"
#import "UILabel+FSHighlightAnimationAdditions.h"
#import <MediaPlayer/MediaPlayer.h>

@interface RYSTSaveVideoViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, copy) NSURL *url;

@end

@implementation RYSTSaveVideoViewController

- (instancetype)initWithURLString:(NSURL *)url presenter:(RYSTVideoViewController *)presenter
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _url = url;
    _presenter = presenter;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.url];
  _moviePlayer.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
  [self.view addSubview:_moviePlayer.view];
  [_moviePlayer prepareToPlay];

  UILabel *submitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 80)];
  submitLabel.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
  submitLabel.textColor = [UIColor whiteColor];
  submitLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:25.0f];
  submitLabel.textAlignment = NSTextAlignmentCenter;
  [submitLabel setTextWithChangeAnimation:NSLocalizedString(@"Swipe to Share >", nil)];
  submitLabel.userInteractionEnabled = YES;
  [self.view addSubview:submitLabel];

  UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSaveVideoWithSave:)];
  swipe.direction = UISwipeGestureRecognizerDirectionRight;
  swipe.numberOfTouchesRequired = 1;
  [submitLabel addGestureRecognizer:swipe];

  UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 40, 40)];
  [exitButton setBackgroundImage:[UIImage imageNamed:@"exit-x-circle"] forState:UIControlStateNormal];
  [exitButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:exitButton];
}

- (void)exit
{
  [self dismissSaveVideoWithSave:nil];
}

- (void)dismissSaveVideoWithSave:(UITapGestureRecognizer *)swipe
{
  [self.presenter dismissSaveVideoWithSave:(swipe != nil)];
}

@end
