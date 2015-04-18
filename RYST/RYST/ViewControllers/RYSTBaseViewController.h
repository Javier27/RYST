//
//  RYSTBaseViewController.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYSTAPIClient.h"

@interface RYSTBaseViewController : UIViewController

// intended for class-based requests, app level requests should be on a shared
// api client, currently this is not required by this application
@property (nonatomic, strong) RYSTAPIClient *apiClient;

- (void)finishFormOperation;
- (void)beginFormOperationWithActivityCaption:(NSString *)activityCaption alpha:(CGFloat)alpha;

@end
