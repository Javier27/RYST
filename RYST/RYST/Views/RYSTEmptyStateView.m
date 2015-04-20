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
    self.backgroundColor = [UIColor colorWithRed:63.0f/255.0f green:225.0f/255.0f blue:181.0f/255.0f alpha:1.0f];

    RYSTActivityIndicatorView *activityIndicatorView = [RYSTActivityIndicatorView new];
    [activityIndicatorView startAnimating];
    [self addSubview:activityIndicatorView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    label.text = activityCaption;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.preferredMaxLayoutWidth = 192.0f;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir-Roman" size:20.0f];
    [label sizeToFit];
    [self addSubview:label];

    activityIndicatorView.center = CGPointMake(self.center.x, self.center.y - 60);
    label.center = CGPointMake(self.center.x, self.center.y + 10);
  }

  return self;
}

@end
