//
//  RYSTAffirmationLabel.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmationLabel.h"

@implementation RYSTAffirmationLabel

- (void)setText:(NSString *)text
{
  [super setText:text];
  self.font = [UIFont fontWithName:@"Avenir-Heavy" size:22.0f];
  self.textColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];

  UIBezierPath *path = [[UIBezierPath alloc] init];
  CGFloat minX = CGRectGetMinX(self.bounds);
  CGFloat minY = CGRectGetMinY(self.bounds);
  CGFloat maxX = CGRectGetMaxX(self.bounds);
  CGFloat maxY = CGRectGetMaxY(self.bounds);
  CGFloat w = CGRectGetWidth(self.bounds);

  [path moveToPoint:CGPointMake(minX, maxY)];
  [path addLineToPoint:CGPointMake(minX + w/7.0f, minY)];
  [path addLineToPoint:CGPointMake(maxX, minY)];
  [path addLineToPoint:CGPointMake(maxX - w/8.0f, maxY)];
  [path addLineToPoint:CGPointMake(minX, maxY)];

  [path closePath];

  [[UIColor colorWithWhite:1.0f alpha:0.5f] setFill];
  [path fill];
}

@end
