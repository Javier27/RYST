//
//  RYSTNiceBanner.m
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTNiceBanner.h"

@implementation RYSTNiceBanner

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0f];

    UIImageView *checkmarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    checkmarkImageView.center = CGPointMake(self.center.x, 30);
    checkmarkImageView.image = [UIImage imageNamed:@"photo-checkmark-icon"];
    [self addSubview:checkmarkImageView];

    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:14.0f];
    [messageLabel sizeToFit];
    messageLabel.center = CGPointMake(self.center.x, 65);
    [self addSubview:messageLabel];
  }

  return self;
}

@end
