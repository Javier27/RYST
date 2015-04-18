//
//  RYSTNiceBanner.h
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//
//  This class assumes it is initialized with a height of kBannerHeight
//  as it is a fixed layout view and it spans the whole view

#import <UIKit/UIKit.h>

static const CGFloat kBannerHeight = 80;

@interface RYSTNiceBanner : UIView

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message;

@end
