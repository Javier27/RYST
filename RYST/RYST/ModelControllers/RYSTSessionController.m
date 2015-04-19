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
  return self.authToken.length > 0;
}

- (void)signInWithEmail:(NSString *)name completionOrNil:(RYSTTokenDelivery)completionOrNil
{
  [self.apiClient signInWithName:name completion:^(RYSTToken *result, NSError *error) {
    if (result) {
      self.authToken = result.token;
      RYSTUserDefaultsSetHasEverSignedIn(YES);
    }

    if (completionOrNil) completionOrNil(result, error);
  }];
}

- (void)signOut
{
  self.authToken = nil;
}

- (void)resetApp
{
  RYSTUserDefaultsSetHasEverSignedIn(NO);
}


- (RYSTAPIClient *)apiClient
{
  if (!_apiClient) {
    _apiClient = [[RYSTAPIClient alloc] init];
  }

  return _apiClient;
}

@end
