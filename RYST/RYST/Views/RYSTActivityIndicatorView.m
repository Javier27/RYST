//
//  RYSTActivityIndicatorView.m
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTActivityIndicatorView.h"

@implementation RYSTActivityIndicatorView

#pragma mark - Init/dealloc

- (id)initWithFrame:(CGRect)frame
{
  NSMutableArray *animationImages = [NSMutableArray array];
  for (int i = 1; i <= 12; i++) {
    [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"empty_loading_%d", i]]];
  }

  self = [super initWithFrame:frame];
  if (self) {
    self.image = animationImages[0];
    self.animationImages = animationImages;
    self.animationDuration = 1.0;     // 12 FPS given 12 frames
  }
  return self;
}

- (id)init
{
  return [self initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
}

@end
