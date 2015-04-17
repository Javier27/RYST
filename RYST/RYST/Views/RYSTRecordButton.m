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
@property (nonatomic, strong) UIButton *playView;

@end

@implementation RYSTRecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _isRecording = NO;

    self.layer.cornerRadius = CGRectGetWidth(frame)/2;
    self.backgroundColor = [UIColor whiteColor];

    _innerView = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, CGRectGetWidth(frame) - 6, CGRectGetHeight(frame) - 6)];
    _innerView.backgroundColor = [UIColor blackColor];
    _innerView.layer.cornerRadius = CGRectGetWidth(frame)/2 - 3;
    [self addSubview:_innerView];

    _playView = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame) - 10, CGRectGetHeight(frame) - 10)];
    _playView.backgroundColor = [UIColor redColor];
    _playView.layer.cornerRadius = CGRectGetWidth(frame)/2 - 5;
    [self addSubview:_playView];
  }

  return self;
}

- (void)toggleRecording
{
  self.isRecording = !self.isRecording;
  if (self.isRecording) {
    [UIView animateWithDuration:0.3f
                     animations:^{
                       self.playView.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.6, 0.6, 1.0);
                     } completion:^(BOOL finished) {
                       self.playView.layer.cornerRadius = 5.0f;
                     }];
  } else {
    [UIView animateWithDuration:0.3f
                     animations:^{
                       self.playView.layer.transform = CATransform3DIdentity;
                       self.playView.layer.cornerRadius = CGRectGetWidth(self.frame)/2 - 5;
                     }];
  }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
  [super addTarget:target action:action forControlEvents:controlEvents];
  [self.innerView addTarget:target action:action forControlEvents:controlEvents];
  [self.playView addTarget:target action:action forControlEvents:controlEvents];
}

@end
