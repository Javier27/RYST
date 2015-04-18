//
//  RYSTSaveVideoViewController.h
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTBaseViewController.h"
@class RYSTVideoViewController;

@interface RYSTSaveVideoViewController : RYSTBaseViewController

@property (nonatomic, strong) RYSTVideoViewController *presenter;

- (instancetype)initWithURLString:(NSURL *)url presenter:(RYSTVideoViewController *)presenter;

@end
