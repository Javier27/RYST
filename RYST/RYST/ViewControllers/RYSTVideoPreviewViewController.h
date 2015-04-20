//
//  RYSTVideoPreviewViewController.h
//  RYST
//
//  Created by Richie Davis on 4/20/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYSTBaseViewController.h"
@class RYSTVideoViewController;

@interface RYSTVideoPreviewViewController : RYSTBaseViewController
@property (nonatomic, strong) RYSTVideoViewController *presenter;
- (instancetype)initWithURL:(NSURL *)URL affirmationText:(NSString *)affirmation;
@end
