//
//  RYSTAPIError.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAPIResult.h"

extern NSString *const RYSTAPIErrorDomain;

@interface RYSTAPIError : NSObject <RYSTAPIResult>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

- (NSError *)NSError;
+ (NSError *)NSErrorWithRestKitError:(NSError *)restKitError statusCode:(NSInteger)statusCode;

@end
