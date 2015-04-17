//
//  RYSTAffirmation.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmation.h"

@implementation RYSTAffirmation

+ (RKObjectMapping *)mapping
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];

  [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"affirmationIdentifier",
                                                 @"text" : @"text" }];

  return mapping;
}

@end
