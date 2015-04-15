//
//  RYSTAPIError.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAPIError.h"

NSString *const RYSTAPIErrorDomain = @"com.davis.development.RYST.RYSTAPIError.domain";
NSString *const RYSTAPIErrorUserInfoKeyErrorObject = @"com.davis.development.RYST.RYSTAPIError.errorUserInfoKey.errorObject";

@implementation RYSTAPIError

- (NSError *)NSError
{
  // just giving a standard error code, if the apis were written out to include error responses I'd implement this
  return [NSError errorWithDomain:RYSTAPIErrorDomain code:400 userInfo:@{ RYSTAPIErrorUserInfoKeyErrorObject : self }];
}

+ (NSError *)NSErrorWithRestKitError:(NSError *)restKitError statusCode:(NSInteger)statusCode
{
  // Find the error object if there was one
  if ([RKErrorDomain isEqualToString:restKitError.domain]) {
    NSArray *errorObjects = restKitError.userInfo[RKObjectMapperErrorObjectsKey];
    if (errorObjects.count == 1) {
      RYSTAPIError *errorObject = errorObjects[0];
      if ([errorObject isKindOfClass:[RYSTAPIError class]]) {
        return [NSError errorWithDomain:RYSTAPIErrorDomain code:statusCode userInfo:@{ RYSTAPIErrorUserInfoKeyErrorObject : errorObject }];
      }
    }
  }

  return [NSError errorWithDomain:RYSTAPIErrorDomain code:statusCode userInfo:nil];
}

+ (RKObjectMapping *)mapping
{
  // assuming this is the mapping, easily manipulated to fit the RYSTAPI
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
  [mapping addAttributeMappingsFromArray:@[ @"title", @"message" ]];
  return mapping;
}

@end
