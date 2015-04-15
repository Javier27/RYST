//
//  RYSTAffirmation.h
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYSTAPIResult.h"

@interface RYSTAffirmation : NSObject <RYSTAPIResult>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, copy) NSString *text;

@end
