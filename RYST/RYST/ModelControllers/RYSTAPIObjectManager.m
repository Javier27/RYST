//
//  RYSTAPIObjectManager.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>

#import "RYSTAPIObjectManager.h"
#import "RYSTAPIEndpoint.h"
#import "RYSTEnvironment.h"

@implementation RYSTAPIObjectManager

#pragma mark - Helpers

- (BOOL)isReachable
{
  AFNetworkReachabilityStatus status = self.HTTPClient.networkReachabilityStatus;
  switch (status) {
    case AFNetworkReachabilityStatusNotReachable:
      return NO;
    case AFNetworkReachabilityStatusUnknown:
    case AFNetworkReachabilityStatusReachableViaWiFi:
    case AFNetworkReachabilityStatusReachableViaWWAN:
      return YES;
  }
  return NO;
}

#pragma mark - Init/dealloc

+ (instancetype)objectManager;
{
  static RYSTAPIObjectManager *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [RYSTAPIObjectManager new];
  });
  return instance;
}

- (id)init
{
  RKLogConfigureByName("RestKit/*", RKLogLevelOff)

  // just use the RK standard for this, we can customized for RYST if we need to
#ifdef DEBUG
  RKLogConfigureByName("RestKit/Network", RKLogLevelError)
#else
  RKLogConfigureByName("RestKit/Network", RKLogLevelOff)
#endif

  RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff)

  // using the base API string, uploads will be put directly on the operation queue until
  // we need to expand for more requests to that URL
  self = [super initWithHTTPClient:[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://"]]];
  if (self) {
    [self.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    self.requestSerializationMIMEType = RKMIMETypeJSON;

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  }
  return self;
}

/**
 * This method is the `RKObjectManager` analog for the method of the same name on `AFHTTPClient`.
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
  NSMutableURLRequest *request;
  if (parameters && !([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"])) {
    request = [self.HTTPClient requestWithMethod:method
                                            path:path
                                      parameters:[self.HTTPClient isMemberOfClass:[AFHTTPClient class]] ? nil : parameters];

    NSError *error = nil;
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.HTTPClient.stringEncoding));

    NSString *requestSerializationMIMEType = [self getRequestSerializationMIMETypeForPath:path method:method];
    [request setValue:[NSString stringWithFormat:@"%@; charset=%@", requestSerializationMIMEType, charset] forHTTPHeaderField:@"Content-Type"];
    NSData *requestBody = [RKMIMETypeSerialization dataFromObject:parameters MIMEType:requestSerializationMIMEType error:&error];
    [request setHTTPBody:requestBody];
  } else {
    request = [self.HTTPClient requestWithMethod:method path:path parameters:parameters];
  }

  return request;
}

- (NSString *)getRequestSerializationMIMETypeForPath:(NSString *)path method:(NSString *)method
{
  return [self shouldUseVideoForRequestWithPath:path method:method] ? @"video/quicktime" : self.requestSerializationMIMEType;
}

/**
 * true if the request is sending mov type
 */
- (BOOL)shouldUseVideoForRequestWithPath:(NSString *)path method:(NSString *)method
{
  return [method isEqualToString:@"POST"] && [path rangeOfString:@"videos/generic/store"].location != NSNotFound;
}

@end
