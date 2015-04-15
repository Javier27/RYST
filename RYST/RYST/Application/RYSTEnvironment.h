//
//  RYSTEnvironment.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYSTEnvironment : NSObject

// NSUserDefaults
void RYSTUserDefaultsInit(void);
NSString *RYSTUserDefaultsGetAuthToken(void);
void RYSTUserDefaultsSetAuthToken(NSString * authToken);
void RYSTUserDefaultsInvalidateAuthToken(void);
BOOL RYSTUserDefaultsGetHasEverSignedIn(void);
void RYSTUserDefaultsSetHasEverSignedIn(BOOL boolValue);

@end
