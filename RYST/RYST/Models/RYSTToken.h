//
//  RYSTToken.h
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYSTAPIResult.h"

@interface RYSTToken : NSObject <RYSTAPIResult>

@property (nonatomic, copy) NSString *token;

@end
