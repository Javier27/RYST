//
//  RYSTAffirmationLabel.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmationLabel.h"
#import "UIView+RJDConvenience.h"

@interface RYSTAffirmationLabel ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation RYSTAffirmationLabel

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];

    _textLabel = [[UILabel alloc] init];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_textLabel];
    [self centerChildren:@[_textLabel]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-50.0f]];
  }

  return self;
}

- (void)setText:(NSString *)text
{
  self.textLabel.text = text;
  self.textLabel.font = [UIFont fontWithName:@"Avenir-BlackOblique" size:20.0f];
  self.textLabel.textColor = [UIColor whiteColor];
  self.textLabel.numberOfLines = 0;
  self.textLabel.textAlignment = NSTextAlignmentCenter;
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
