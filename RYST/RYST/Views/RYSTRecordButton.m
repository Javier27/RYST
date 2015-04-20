//
//  RYSTRecordButton.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTRecordButton.h"
#import "UIView+RJDConvenience.h"

@interface RYSTRecordButton ()

@property (nonatomic) BOOL isRecording;
@property (nonatomic, strong) UIButton *innerView;

@end

@implementation RYSTRecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _isRecording = NO;

    self.layer.cornerRadius = CGRectGetWidth(frame)/2;
    self.backgroundColor = [UIColor darkGrayColor];
    self.alpha = 0.85f;

    _innerView = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, CGRectGetWidth(frame) - 6, CGRectGetHeight(frame) - 6)];
    _innerView.backgroundColor = [UIColor lightGrayColor];
    _innerView.layer.cornerRadius = CGRectGetWidth(frame)/2 - 3;
    [self addSubview:_innerView];
  }

  return self;
}

- (void)toggleRecording
{
  self.isRecording = !self.isRecording;
  self.backgroundColor = self.isRecording ? [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f] : [UIColor darkGrayColor];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
  [super addTarget:target action:action forControlEvents:controlEvents];
  [self.innerView addTarget:target action:action forControlEvents:controlEvents];
}

@end
