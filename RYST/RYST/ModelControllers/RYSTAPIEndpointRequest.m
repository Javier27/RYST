//
//  RYSTAPIEndpointRequest.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAPIEndpointRequest.h"
#import "RYSTAPIError.h"
#import "RYSTAPIObjectManager.h"
#import "RYSTEnvironment.h"
#import "RYSTSessionController.h"
#import <RestKit/RestKit.h>

static NSString *const kHeaderRYSTToken = @"X-RYST-Token";

@interface RYSTAPIEndpointRequest ()

@property (nonatomic, strong, readwrite) RYSTAPIEndpoint *endpoint;
@property (nonatomic, copy) NSString *pathSuffix;
@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, strong) id object;
@property (nonatomic, copy, readwrite) RYSTMappingResultDelivery completion;

@end

@implementation RYSTAPIEndpointRequest

#pragma mark - Helpers

- (void)addAuthHeadersToRequest:(NSMutableURLRequest *)request
{
  NSString *sessionToken = [RYSTSessionController sessionController].authToken;
  if (0 < sessionToken.length) [request addValue:sessionToken forHTTPHeaderField:kHeaderRYSTToken];
}

#pragma mark - Init/dealloc

+ (RYSTAPIEndpointRequest *)requestWithEndpoint:(RYSTAPIEndpointName)endpointName
                                     pathSuffix:(NSString *)suffixOrNil
                                         params:(NSDictionary *)paramsOrNil
                                         object:(id)object
                                     completion:(RYSTMappingResultDelivery)deliveryOrNil;
{
  RYSTAPIEndpointRequest *request = [RYSTAPIEndpointRequest new];
  request.endpoint = [RYSTAPIEndpoint endpointWithName:endpointName];
  request.pathSuffix = suffixOrNil;
  request.params = paramsOrNil;
  request.object = object;
  request.completion = deliveryOrNil;
  return request;
}

#pragma mark - Public interface

- (RKObjectRequestOperation *)operation
{
  RKRequestMethod method = self.endpoint.method;
  NSString *path = self.endpoint.path;
  if (self.pathSuffix) {
    if ([path rangeOfString:@"%@"].location != NSNotFound) {
      path = [NSString stringWithFormat:path, self.pathSuffix];
    } else {
      path = [path stringByAppendingPathComponent:self.pathSuffix];
    }
  }

  NSMutableURLRequest *request = [[RYSTAPIObjectManager objectManager] requestWithObject:self.object method:method path:path parameters:self.params];
  [self addAuthHeadersToRequest:request];

  RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:self.endpoint.responseDescriptors];
  RYSTMappingResultDelivery completion = [self.completion copy];

  [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    if (completion) completion(mappingResult, nil);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    if (completion) completion(nil, error);
  }];

  return operation;
}

#pragma mark - NSObject

- (NSString *)description
{
  NSString *method = nil;
  switch (self.endpoint.method) {
    case RKRequestMethodGET:
      method = @"GET";
      break;
    case RKRequestMethodPUT:
      method = @"PUT";
      break;
    case RKRequestMethodPOST:
      method = @"POST";
      break;
    case RKRequestMethodDELETE:
      method = @"DELETE";
      break;
    default:
      method = @"(Other)";
      break;
  }

  return [NSString stringWithFormat:@"%@, %@ %@ %@: %@", [super description], method, self.endpoint.path, self.pathSuffix ? : @"", self.params];
}

@end
