//
//  RYSTVideoViewController.h
//  RYST
//
//  Created by Richie Davis on 4/20/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYSTBaseViewController.h"

@interface RYSTVideoViewController : RYSTBaseViewController

- (void)dismissAndRepeat;
- (void)dismissPreviewShouldSave:(BOOL)shouldSave;

@end
