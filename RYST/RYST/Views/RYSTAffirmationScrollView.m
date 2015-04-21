//
//  RYSTAffirmationScrollView.m
//  RYST
//
//  Created by Richie Davis on 4/20/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmationScrollView.h"
#import "RYSTAffirmationLabel.h"
#import "RYSTAffirmation.h"

static CGFloat kOverlapForRotation = 80;

@interface RYSTAffirmationScrollView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *affirmations;
@property (nonatomic) int affirmationIndex;

@property (nonatomic, strong) RYSTAffirmationLabel *leftAffirmation;
@property (nonatomic, strong) RYSTAffirmationLabel *rightAffirmation;
@property (nonatomic, strong) RYSTAffirmationLabel *centerAffirmation;

@property (nonatomic) NSInteger state; // 0 is left, 1 is center, 2 is right

@end

@implementation RYSTAffirmationScrollView

- (instancetype)initWithFrame:(CGRect)frame affirmations:(NSArray *)affirmations
{
  self = [super initWithFrame:frame];
  if (self) {
    _affirmations = affirmations;
    _affirmationIndex = 0;
    _state = 1;

    [self setShowsHorizontalScrollIndicator:NO];
    self.delegate = self;

    self.contentSize = CGSizeMake(CGRectGetWidth(frame) * 3, CGRectGetHeight(frame));
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    [self initializeAffirmations];
  }

  return self;
}

- (NSString *)currentAffirmation
{
  if (!self.affirmations) return nil;
  return ((RYSTAffirmation *)self.affirmations[self.affirmationIndex]).text;
}

- (void)initializeAffirmations
{
  _centerAffirmation = [[RYSTAffirmationLabel alloc] initWithFrame:CGRectMake(0, 0, 210, 80)];
  _centerAffirmation.text = ((RYSTAffirmation *)self.affirmations[0]).text;
  _centerAffirmation.rectColor = [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  _centerAffirmation.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_centerAffirmation];

  _centerAffirmation.center = CGPointMake(1.5 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);

  [self createLeftAffirmation];
  [self createRightAffirmation];
}

- (void)createRightAffirmation
{
  int index = (self.affirmationIndex == self.affirmations.count - 1) ? 0 : self.affirmationIndex + 1;

  _rightAffirmation = [[RYSTAffirmationLabel alloc] initWithFrame:CGRectMake(0, 0, 210, 80)];
  _rightAffirmation.text = ((RYSTAffirmation *)self.affirmations[index]).text;
  _rightAffirmation.rectColor = [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  _rightAffirmation.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_rightAffirmation];

  _rightAffirmation.center = CGPointMake(2.5 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
}

- (void)createLeftAffirmation
{
  int index = self.affirmationIndex == 0 ? self.affirmations.count - 1 : self.affirmationIndex - 1;

  _leftAffirmation = [[RYSTAffirmationLabel alloc] initWithFrame:CGRectMake(0, 0, 210, 80)];
  _leftAffirmation.text = ((RYSTAffirmation *)self.affirmations[index]).text;
  _leftAffirmation.textAlignment = NSTextAlignmentCenter;
  _leftAffirmation.rectColor = [UIColor colorWithRed:174.0f/255.0f green:0.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
  [self addSubview:_leftAffirmation];

  _leftAffirmation.center = CGPointMake(0.5 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
}

- (void)removeAffirmations
{
  if (self.centerAffirmation) [self.centerAffirmation removeFromSuperview];
  self.centerAffirmation = nil;
  if (self.rightAffirmation) [self.rightAffirmation removeFromSuperview];
  self.rightAffirmation = nil;
  if (self.leftAffirmation) [self.leftAffirmation removeFromSuperview];
  self.leftAffirmation = nil;
}

#pragma mark UIScrollViewMethods

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  self.userInteractionEnabled = NO;

  if (velocity.x != 0) {
    if (velocity.x > 0) {
      self.state = 2;
      targetContentOffset->x = 0;
    } else {
      self.state = 0;
      targetContentOffset->x = 2 * CGRectGetWidth(self.frame);
    }
  } else {
    if (scrollView.contentOffset.x > kOverlapForRotation + CGRectGetWidth(self.frame)) {
      self.state = 0;
      [scrollView setContentOffset:CGPointMake(2 * CGRectGetWidth(self.frame), 0) animated:YES];
    } else if (scrollView.contentOffset.x < CGRectGetWidth(self.frame) - kOverlapForRotation) {
      self.state = 2;
      [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
      [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:YES];
    }
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  self.userInteractionEnabled = NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  self.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  self.userInteractionEnabled = YES;
  [self syncView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  self.userInteractionEnabled = YES;
  [self syncView];
}

- (void)syncView
{
  if (self.state == 1) return;
  if (self.state == 0) {
    self.affirmationIndex = (self.affirmationIndex == self.affirmations.count - 1) ? 0 : self.affirmationIndex + 1;
    [_leftAffirmation removeFromSuperview];
    _leftAffirmation = nil;
    _rightAffirmation.center = CGPointMake(1.5 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
    _centerAffirmation.center = CGPointMake(0.5 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
    _leftAffirmation = _centerAffirmation;
    _centerAffirmation = _rightAffirmation;
    [self createRightAffirmation];
  } else if (self.state == 2) {
    self.affirmationIndex = (self.affirmationIndex == 0) ? self.affirmations.count - 1 : self.affirmationIndex - 1;
    [_rightAffirmation removeFromSuperview];
    _rightAffirmation = nil;
    _leftAffirmation.center = CGPointMake(1.5 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
    _centerAffirmation.center = CGPointMake(2.5 * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
    _rightAffirmation = _centerAffirmation;
    _centerAffirmation = _leftAffirmation;
    [self createLeftAffirmation];
  }

  [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
}

@end
