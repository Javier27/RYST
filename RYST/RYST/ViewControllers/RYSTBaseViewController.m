//
//  RYSTBaseViewController.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTBaseViewController.h"
#import "RYSTEmptyStateView.h"

@interface RYSTBaseViewController ()

@property (nonatomic, readwrite, strong) RYSTEmptyStateView *presentedEmptyStateView;

@end

@implementation RYSTBaseViewController

- (RYSTAPIClient *)apiClient
{
  if (!_apiClient) {
    _apiClient = [RYSTAPIClient new];
  }
  return _apiClient;
}

- (void)beginFormOperationWithActivityCaption:(NSString *)activityCaption alpha:(CGFloat)alpha
{
  // Dismiss the keyboard and show a loading state.
  [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

  RYSTEmptyStateView *emptyView = [[RYSTEmptyStateView alloc] initWithFrame:self.view.bounds
                                                            activityCaption:activityCaption];
  emptyView.alpha = alpha;

  emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.presentedEmptyStateView = emptyView;
  [self.view addSubview:emptyView];
}

- (void)finishFormOperation
{
  [self.presentedEmptyStateView removeFromSuperview];
  self.presentedEmptyStateView = nil;
}

@end