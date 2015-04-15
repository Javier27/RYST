//
//  RYSTEnvironment.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTEnvironment.h"

static NSString *const kRYSTEUserDefaultsKeyHasEverSignedIn = @"com.davis.development.RYST.userDefaults.hasEverSignedIn";
static NSString *const kRYSTEUserDefaultsKeyAuthToken = @"com.davis.development.RYST.userDefaults.authToken";

@implementation RYSTEnvironment

void RYSTUserDefaultsInit(void)
{
  NSDictionary *defaultValues = @{ kRYSTEUserDefaultsKeyHasEverSignedIn : @NO,
                                   kRYSTEUserDefaultsKeyAuthToken : @""};
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

NSString *RYSTUserDefaultsGetAuthToken(void)
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:kRYSTEUserDefaultsKeyAuthToken];
}

void RYSTUserDefaultsSetAuthToken(NSString *authToken)
{
  [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kRYSTEUserDefaultsKeyAuthToken];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

void RYSTUserDefaultsInvalidateAuthToken(void)
{
  RYSTUserDefaultsSetAuthToken(@"");
}

BOOL RYSTUserDefaultsGetHasEverSignedIn(void)
{
  return [[[NSUserDefaults standardUserDefaults] objectForKey:kRYSTEUserDefaultsKeyHasEverSignedIn] boolValue];
}

void RYSTUserDefaultsSetHasEverSignedIn(BOOL boolValue)
{
  NSNumber *value = @(boolValue);
  [[NSUserDefaults standardUserDefaults] setObject:value forKey:kRYSTEUserDefaultsKeyHasEverSignedIn];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
