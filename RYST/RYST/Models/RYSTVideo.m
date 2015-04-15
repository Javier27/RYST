//
//  RYSTVideo.m
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTVideo.h"

@implementation RYSTVideo

#pragma mark - RYSTAPIResult

+ (RKObjectMapping *)mapping
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];

  [mapping addAttributeMappingsFromDictionary:@{ @"class" : @"classString",
                                                 @"id" : @"identifier",
                                                 @"media_type" : @"mediaTypeString",
                                                 @"url" : @"url" }];
  return mapping;
}

@end
