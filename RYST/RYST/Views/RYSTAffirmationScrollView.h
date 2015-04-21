//
//  RYSTAffirmationScrollView.h
//  RYST
//
//  Created by Richie Davis on 4/20/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYSTAffirmationScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame affirmations:(NSArray *)affirmations;
- (NSString *)currentAffirmation;

@end
