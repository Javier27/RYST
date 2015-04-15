//
//  RYSTSessionController.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYSTAPIClient.h"

@interface RYSTSessionController : NSObject

@property (nonatomic, copy) NSString *authToken;

+ (instancetype)sessionController;

- (BOOL)isSignedIn;
- (void)signInWithEmail:(NSString *)name completionOrNil:(RYSTTokenDelivery)completionOrNil;
- (void)signOut;
- (void)resetApp; // this is for demonstrative purposes
@end
