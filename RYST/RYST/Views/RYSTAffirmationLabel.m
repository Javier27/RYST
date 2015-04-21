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
  self.font = [UIFont fontWithName:@"Avenir-BlackOblique" size:20.0f];
  self.textColor = [UIColor whiteColor];
  self.numberOfLines = 0;
}

- (void)drawRect:(CGRect)rect
{
  UIBezierPath *path = [[UIBezierPath alloc] init];
  CGFloat minX = CGRectGetMinX(self.bounds);
  CGFloat minY = CGRectGetMinY(self.bounds);
  CGFloat maxX = CGRectGetMaxX(self.bounds);
  CGFloat maxY = CGRectGetMaxY(self.bounds);
  CGFloat w = CGRectGetWidth(self.bounds);

  [path moveToPoint:CGPointMake(minX, maxY)];
  [path addLineToPoint:CGPointMake(minX + w/6.0f, minY)];
  [path addLineToPoint:CGPointMake(maxX, minY)];
  [path addLineToPoint:CGPointMake(maxX - w/7.0f, maxY)];
  [path addLineToPoint:CGPointMake(minX, maxY)];

  [path closePath];

  [[self.rectColor colorWithAlphaComponent:0.4f] setFill];
  [path fill];

  [super drawRect:rect];
}

@end
