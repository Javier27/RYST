//
//  RYSTBaseViewController.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTBaseViewController.h"

@implementation RYSTBaseViewController

- (RYSTAPIClient *)apiClient
{
  if (!_apiClient) {
    _apiClient = [RYSTAPIClient new];
  }
  return _apiClient;
}

@end
