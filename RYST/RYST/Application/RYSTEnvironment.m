//
//  RYSTEnvironment.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTEnvironment.h"

static NSString *const kRYSTEUserDefaultsKeyHasEverSignedIn = @"com.davis.development.RYST.userDefaults.hasEverSignedIn";

@implementation RYSTEnvironment

void RYSTUserDefaultsInit(void)
{
  NSDictionary *defaultValues = @{ kRYSTEUserDefaultsKeyHasEverSignedIn : @NO };
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
  [[NSUserDefaults standardUserDefaults] synchronize];
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
