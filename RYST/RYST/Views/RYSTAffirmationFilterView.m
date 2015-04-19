//
//  RYSTAffirmationFilterView.m
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmationFilterView.h"
#import "RYSTAffirmation.h"

static const CGFloat kCellHeight = 49.0f;
static const CGFloat kVerticalSeparator = 1.0f;
static const CGFloat kTablePadding = 3.0f;
static const CGFloat kMaxContainerHeight = 270.0f;
static const CGFloat kContainerWidth = 260.0f;
static const CGFloat kHeaderHeight = 70.0f;

@interface RYSTAffirmationFilterView ()

@property (nonatomic, copy) NSArray *affirmations;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RYSTAffirmationFilterView

- (instancetype)initWithFrame:(CGRect)frame affirmations:(NSArray *)affirmations
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];

    _affirmations = affirmations;

    CGFloat scrollViewHeight = affirmations.count > 4 ? kMaxContainerHeight : (affirmations.count + 1) * (kCellHeight + kVerticalSeparator);
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 kContainerWidth + 2 * kTablePadding,
                                                                 scrollViewHeight + kHeaderHeight + 3 * kTablePadding)];
    container.center = self.center;
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];

    UILabel *tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTablePadding, kTablePadding, kContainerWidth, kHeaderHeight)];
    tableHeaderLabel.textAlignment = NSTextAlignmentCenter;
    tableHeaderLabel.backgroundColor = [UIColor colorWithRed:(111.0/255.0) green:(168.0/255.0) blue:(255.0/255.0) alpha:1.0];
    tableHeaderLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:14.0f];
    tableHeaderLabel.textColor = [UIColor whiteColor];
    tableHeaderLabel.text = NSLocalizedString(@"Pick a Filter", nil);
    [container addSubview:tableHeaderLabel];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kTablePadding,
                                                                 2 * kTablePadding + kHeaderHeight,
                                                                 kContainerWidth,
                                                                 scrollViewHeight)];

    _scrollView.contentSize = CGSizeMake(kContainerWidth, (affirmations.count + 1) * (kCellHeight + kVerticalSeparator));
    [container addSubview:_scrollView];

    CGRect frame = CGRectMake(0, kVerticalSeparator, kContainerWidth, kCellHeight);
    for (NSInteger i = 0; i <= affirmations.count; i++) {
      NSString *title = NSLocalizedString(@"None", nil);
      if (i > 0) title = ((RYSTAffirmation *)self.affirmations[i - 1]).text;
      UIButton *affirmationButton = [[UIButton alloc] initWithFrame:frame];
      affirmationButton.backgroundColor = [UIColor colorWithRed:(161.0/255.0) green:(198.0/255.0) blue:(255.0/255.0) alpha:1.0];
      [affirmationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [affirmationButton setTitle:title forState:UIControlStateNormal];
      affirmationButton.tag = i;
      [affirmationButton addTarget:self action:@selector(affirmationSelected:) forControlEvents:UIControlEventTouchUpInside];
      [self.scrollView addSubview:affirmationButton];

      frame.origin.y += kCellHeight + kVerticalSeparator;
    }

    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(container.frame) - 12,
                                                                       CGRectGetMinY(container.frame) - 12,
                                                                       30,
                                                                       30)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"exit-black-x-circle"] forState:UIControlStateNormal];
    closeButton.tag = -1;
    [closeButton addTarget:self action:@selector(affirmationSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
  }

  return self;
}

- (void)affirmationSelected:(id)sender
{
  UIButton *affirmationButton = (UIButton *)sender;
  if (affirmationButton.tag == -1) {
    [self.delegate affirmationSelected:nil shouldUpdate:NO];
  } else if (affirmationButton.tag == 0) {
    [self.delegate affirmationSelected:nil shouldUpdate:YES];
  } else {
    [self.delegate affirmationSelected:self.affirmations[affirmationButton.tag - 1] shouldUpdate:YES];
  }

}

@end
