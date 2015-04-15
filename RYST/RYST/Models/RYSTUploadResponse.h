//
//  RYSTUploadResponse.h
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAPIResult.h"
@class RYSTAffirmation;

@interface RYSTUploadResponse : NSObject <RYSTAPIResult>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) RYSTAffirmation *affirmation;

@end
