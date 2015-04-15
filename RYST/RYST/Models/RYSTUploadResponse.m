//
//  RYSTUploadResponse.m
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTUploadResponse.h"
#import "RYSTAffirmation.h"

@implementation RYSTUploadResponse

+ (RKObjectMapping *)mapping
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];

  [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"identifier",
                                                 @"url" : @"url" }];
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"affirmation"
                                                                          toKeyPath:@"affirmation"
                                                                        withMapping:[RYSTAffirmation mapping]]];
  return mapping;
}

@end
