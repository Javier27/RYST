//
//  RYSTAPIClient.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "RYSTAPIClient.h"
#import "RYSTAPIEndpoint.h"
#import "RYSTAPIEndpointRequest.h"
#import "RYSTAPIError.h"
#import "RYSTAPIObjectManager.h"
#import "RYSTEnvironment.h"
#import "RYSTSessionController.h"
#import "RYSTUploadResponse.h"

@interface RYSTAPIClient ()

@property (nonatomic, strong) NSMutableSet *queuedOperations;

@end

@implementation RYSTAPIClient

#pragma mark - Helpers

- (RYSTMappingResultDelivery)mappingResultObjectDelivery:(RYSTObjectDelivery)outerCompletionOrNil
{
  if (outerCompletionOrNil) {
    return ^(RKMappingResult *result, NSError *error) {
      outerCompletionOrNil(result.firstObject, error);
    };
  }
  return nil;
}

- (RYSTMappingResultDelivery)mappingResultArrayDelivery:(RYSTArrayDelivery)outerCompletionOrNil
{
  if (outerCompletionOrNil) {
    return ^(RKMappingResult *result, NSError *error) {
      outerCompletionOrNil(result.array, error);
    };
  }
  return nil;
}

#pragma mark - Operation Methods

- (void)startOperation:(NSOperation *)operation
{
  [operation addObserver:self forKeyPath:@"isFinished" options:0 context:NULL];
  [self.queuedOperations addObject:operation];

  if ([operation isKindOfClass:[RKObjectRequestOperation class]]) {
    [[RYSTAPIObjectManager objectManager] enqueueObjectRequestOperation:(RKObjectRequestOperation *)operation];
  } else if ([operation isKindOfClass:[AFHTTPRequestOperation class]]) {
    [[RYSTAPIObjectManager objectManager].HTTPClient enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation];
  } else {
    [self releaseOperation:operation];
  }
}

- (void)releaseOperation:(NSOperation *)operation
{
  if ([self.queuedOperations containsObject:operation]) {
    [self.queuedOperations removeObject:operation];
    [operation removeObserver:self forKeyPath:@"isFinished"];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([@"isFinished" isEqual:keyPath] && [object isFinished]) {
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{ [weakSelf releaseOperation:object]; }];
  }
}

#pragma mark - Init/Dealloc

- (id)init
{
  self = [super init];
  if (self) {
    _queuedOperations = [NSMutableSet set];
  }
  return self;
}

- (void)dealloc
{
  [self cancelAllOperations];
}

#pragma mark - Public Interface

- (BOOL)isAPIReachable
{
  return [RYSTAPIObjectManager objectManager].isReachable;
}

- (void)cancelAllOperations
{
  for (NSOperation *operation in self.queuedOperations.allObjects) {
    [self releaseOperation:operation];
    [operation cancel];
  }
}

#pragma mark API Requests

- (void)signInWithName:(NSString *)name completion:(RYSTTokenDelivery)completionOrNil
{
  [self startOperation:[[RYSTAPIEndpointRequest requestWithEndpoint:RYSTAPIEndpointNameSignIn
                                                         pathSuffix:nil
                                                             params:@{ @"name" : name }
                                                             object:nil
                                                         completion:[self mappingResultObjectDelivery:completionOrNil]] operation]];
}

- (void)getAffirmations:(NSNumber *)numAffirmations completion:(RYSTArrayDelivery)completionOrNil
{
  [self startOperation:[[RYSTAPIEndpointRequest requestWithEndpoint:RYSTAPIEndpointNameGetAffirmations
                                                         pathSuffix:nil
                                                             params:@{ @"n" : numAffirmations }
                                                             object:nil
                                                         completion:[self mappingResultArrayDelivery:completionOrNil]] operation]];
}

- (void)addVideoWithURL:(NSString *)videoURL
          affirmationId:(NSNumber *)affirmationId
             completion:(RYSTVideoDelivery)completionOrNil
{
  [self startOperation:[[RYSTAPIEndpointRequest requestWithEndpoint:RYSTAPIEndpointNameAddVideo
                                                         pathSuffix:nil
                                                             params:@{ @"affirmation_id" : affirmationId, @"url" : videoURL }
                                                             object:nil
                                                         completion:[self mappingResultObjectDelivery:completionOrNil]] operation]];
}

- (void)getVideos:(NSNumber *)affirmationId completion:(RYSTArrayDelivery)completionOrNil
{
  [self startOperation:[[RYSTAPIEndpointRequest requestWithEndpoint:RYSTAPIEndpointNameGetVideos
                                                         pathSuffix:nil
                                                             params:nil
                                                             object:nil
                                                         completion:[self mappingResultArrayDelivery:completionOrNil]] operation]];
}

#pragma mark UPLOAD Requests

- (void)uploadVideo:(NSData *)movieData completion:(RYSTUploadResponseDelivery)completionOrNil
{
  AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://ryst-video-uploader.elasticbeanstalk.com"]];

  NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/videos/store/clip" parameters:nil];

  NSString *sessionToken = [RYSTSessionController sessionController].authToken;
  if (0 < sessionToken.length) [request addValue:sessionToken forHTTPHeaderField:kHeaderRYSTToken];
  [request addValue:@"video/quicktime" forHTTPHeaderField:@"Content-Type"];

  [request setHTTPBody:movieData];

  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

//  [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//    NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//  }];

  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (completionOrNil) completionOrNil([RYSTUploadResponse objectFromJSONData:responseObject], nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completionOrNil) completionOrNil(nil, error);
  }];

  [operation start];
}

//- (void)uploadVideo:(NSData *)movieData  withTemp:(BOOL)temp completion:(RYSTUploadResponseDelivery)completionOrNil
//{
//  NSURL *requestURL = [NSURL URLWithString:@"http://ryst-video-uploader.elasticbeanstalk.com/videos/store/clip"];
//  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
//  [request setHTTPMethod:@"POST"];
//
//  NSString *sessionToken = [RYSTSessionController sessionController].authToken;
//  if (0 < sessionToken.length) [request addValue:sessionToken forHTTPHeaderField:kHeaderRYSTToken];
//  [request addValue:@"video/quicktime" forHTTPHeaderField:@"Content-Type"];
//  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//
//  [request setHTTPBody:movieData];
//
//  RKObjectMapping *responseMapping = [RYSTUploadResponse mapping];
//
//  NSIndexSet *successStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
//  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
//                                                                                          method:RKRequestMethodAny
//                                                                                     pathPattern:@"store/clip"
//                                                                                         keyPath:nil
//                                                                                     statusCodes:successStatusCodes];
//
//  RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
//
//  RYSTMappingResultDelivery completion = [self mappingResultObjectDelivery:completionOrNil];
//
//  [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//    if (completion) completion(mappingResult, nil);
//  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//    if ([RKErrorDomain isEqualToString:error.domain]) {
//      error = [RYSTAPIError NSErrorWithRestKitError:error statusCode:operation.HTTPRequestOperation.response.statusCode];
//    }
//    if (completion) completion(nil, error);
//  }];
//
//  [self startOperation:operation];
//}

@end
