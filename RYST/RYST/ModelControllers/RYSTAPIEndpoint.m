//
//  RYSTAPIEndpoint.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAPIEndpoint.h"
#import "RYSTAPIError.h"
#import "RYSTAffirmation.h"
#import "RYSTToken.h"
#import "RYSTUploadResponse.h"
#import "RYSTVideo.h"

static NSDictionary *_endpointsByName;

@implementation RYSTAPIEndpoint

#pragma mark - Init/dealloc

+ (void)initialize
{
  // Mappings are expensive to create, so create them all up front and share them among endpoints.
#define MAPPING(CLASS) RKObjectMapping *mappingTo##CLASS = [CLASS mapping];
  MAPPING(RYSTAffirmation)
  MAPPING(RYSTToken)
  MAPPING(RYSTUploadResponse)
  MAPPING(RYSTVideo)
  MAPPING(RYSTAPIError)
#undef MAPPING

  NSIndexSet *successStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
  NSMutableIndexSet *failureStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError).mutableCopy;
  [failureStatusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];

  RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mappingToRYSTAPIError method:RKRequestMethodAny pathPattern:nil keyPath:@"error" statusCodes:failureStatusCodes];

  NSMutableDictionary *endpointsByName = [NSMutableDictionary dictionary];

#define API_BASE_URL @"ryst-api.elasticbeanstalk.com/"
#define UPLOAD_BASE_URL @"ryst-video-uploader.elasticbeanstalk.com/"

#define ENDPOINT(NAME, METHOD, PATH, PATTERN, KEYPATH, CLASS) \
{ \
RYSTAPIEndpoint *endpoint = [RYSTAPIEndpoint new]; \
endpoint.method = RKRequestMethod##METHOD; \
endpoint.path = PATH; \
RKResponseDescriptor *successDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mappingTo##CLASS method:RKRequestMethodAny pathPattern:PATTERN keyPath:KEYPATH statusCodes:successStatusCodes]; \
endpoint.responseDescriptors = @[ successDescriptor, errorDescriptor ]; \
endpointsByName[@(RYSTAPIEndpointName##NAME)] = endpoint; \
}

  ENDPOINT(SignIn,            POST,     @"tokens/generate",       nil,                        nil,      RYSTToken)
  ENDPOINT(GetAffirmations,   GET,      @"affirmations/random",   @"/affirmations/random",    nil,      RYSTAffirmation)
  ENDPOINT(AddVideo,          POST,     @"videos/",               nil,                        nil,      RYSTVideo)
  ENDPOINT(GetVideos,         GET,      @"videos/",               nil,                        nil,      RYSTVideo)

#undef ENDPOINT

  _endpointsByName = endpointsByName.copy;
}

#pragma mark - Public interface

+ (instancetype)endpointWithName:(RYSTAPIEndpointName)name
{
  return _endpointsByName[@(name)];
}

@end
