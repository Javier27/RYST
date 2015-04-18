//
//  RYSTEmptyStateView.m
//  RYST
//
//  Created by Richie Davis on 4/17/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTActivityIndicatorView.h"
#import "RYSTEmptyStateView.h"

@implementation RYSTEmptyStateView

#pragma mark - Init/dealloc

- (instancetype)initWithFrame:(CGRect)frame activityCaption:(NSString *)activityCaption
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0f];

    RYSTActivityIndicatorView *activityIndicatorView = [RYSTActivityIndicatorView new];
    [activityIndicatorView startAnimating];
    [self addSubview:activityIndicatorView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = activityCaption;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.preferredMaxLayoutWidth = 192.0f;
    label.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    label.font = [UIFont fontWithName:@"Avenir-Heavy" size:14.0f];
    [label sizeToFit];
    [self addSubview:label];

    activityIndicatorView.center = self.center;
    label.center = CGPointMake(self.center.x, self.center.y + 40);
  }

  return self;
}

@end
