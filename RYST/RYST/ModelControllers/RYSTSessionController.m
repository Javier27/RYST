//
//  RYSTSessionController.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTSessionController.h"
#import "RYSTEnvironment.h"
#import "RYSTToken.h"

@interface RYSTSessionController ()

@property (nonatomic, strong) RYSTAPIClient *apiClient;

@end

@implementation RYSTSessionController

+ (instancetype)sessionController
{
  static RYSTSessionController *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[RYSTSessionController alloc] init];
  });

  return instance;
}

- (BOOL)isSignedIn
{
  // for now we will just assume that auth tokens don't expire,
  // in practice I would reauth here
  self.authToken = RYSTUserDefaultsGetAuthToken();
  return self.authToken.length > 0;
}

- (RYSTAPIClient *)apiClient
{
  if (!_apiClient) {
    _apiClient = [[RYSTAPIClient alloc] init];
  }

  return _apiClient;
}

@end
