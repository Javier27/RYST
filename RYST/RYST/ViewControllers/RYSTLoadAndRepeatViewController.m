//
//  RYSTLoadAndRepeatViewController.m
//  RYST
//
//  Created by Richie Davis on 4/20/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTLoadAndRepeatViewController.h"
#import "RYSTVideoViewController.h"

@interface RYSTLoadAndRepeatViewController ()

@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation RYSTLoadAndRepeatViewController

- (instancetype)initWithURL:(NSURL *)URL
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _videoURL = URL;
  }

  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor colorWithRed:63.0f/255.0f green:225.0f/255.0f blue:181.0f/255.0f alpha:1.0f];

  UIButton *repeatImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 37)];
  repeatImage.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
  [repeatImage setBackgroundImage:[UIImage imageNamed:@"start-over"] forState:UIControlStateNormal];
  [repeatImage addTarget:self action:@selector(repeat) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:repeatImage];

  UILabel *namasteLabel = [[UILabel alloc] init];
  namasteLabel.translatesAutoresizingMaskIntoConstraints = NO;
  namasteLabel.textColor = [UIColor whiteColor];
  namasteLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:22.0f];
  namasteLabel.text = NSLocalizedString(@"Namaste.", nil);
  namasteLabel.numberOfLines = 0;
  namasteLabel.textAlignment = NSTextAlignmentCenter;
  [namasteLabel sizeToFit];
  namasteLabel.center = self.view.center;
  [self.view addSubview:namasteLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [self beginFormOperationWithActivityCaption:NSLocalizedString(@"Sending your positive energy to the cloud.", nil) alpha:1.0f];
  NSData *videoData = [NSData dataWithContentsOfURL:self.videoURL];
  [self.apiClient uploadVideo:videoData completion:^(RYSTUploadResponse *result, NSError *error) {
    [self finishFormOperation];
  }];
}

- (void)repeat
{
  [self.presenter dismissAndRepeat];
}

@end
