//
//  RYSTAPIClient.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DELIVERY_TYPE(CLASS) \
@class RYST ## CLASS; \
typedef void (^RYST ## CLASS ## Delivery)(RYST ## CLASS *result, NSError *error);

DELIVERY_TYPE(Token)
DELIVERY_TYPE(Video)
DELIVERY_TYPE(UploadResponse)
typedef void (^RYSTArrayDelivery)(NSArray *result, NSError *error);
typedef void (^RYSTObjectDelivery)(id result, NSError *error);

#undef DELIVERY_TYPE

@interface RYSTAPIClient : NSObject

- (BOOL)isAPIReachable;
- (void)cancelAllOperations;

// API requests
- (void)signInWithName:(NSString *)name completion:(RYSTTokenDelivery)completionOrNil;
- (void)getAffirmations:(NSNumber *)numAffirmations completion:(RYSTArrayDelivery)completionOrNil;
- (void)addVideoWithURL:(NSString *)videoURL
          affirmationId:(NSNumber *)affirmationId
             completion:(RYSTVideoDelivery)completionOrNil;
- (void)getVideos:(NSNumber *)affirmationId completion:(RYSTArrayDelivery)completionOrNil;

// UPLOAD resquest
- (void)uploadVideo:(NSData *)movieData completion:(RYSTUploadResponseDelivery)completionOrNil;

@end
