//
//  RYSTBaseTableViewController.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTBaseTableViewController.h"

@implementation RYSTBaseTableViewController

- (RYSTAPIClient *)apiClient
{
  if (!_apiClient) {
    _apiClient = [RYSTAPIClient new];
  }
  return _apiClient;
}

@end
