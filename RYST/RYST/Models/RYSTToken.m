//
//  RYSTToken.m
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTToken.h"

@implementation RYSTToken

+ (RKObjectMapping *)mapping
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];

  [mapping addAttributeMappingsFromDictionary:@{ @"token" : @"token" }];

  return mapping;
}

@end
