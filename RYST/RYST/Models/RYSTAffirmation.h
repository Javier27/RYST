//
//  RYSTAffirmation.h
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAPIResult.h"

@interface RYSTAffirmation : NSObject <RYSTAPIResult>

@property (nonatomic, strong) NSNumber *affirmationIdentifier;
@property (nonatomic, copy) NSString *text;

@end
