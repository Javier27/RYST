//
//  RYSTAffirmationFilterView.h
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RYSTAffirmation;

@protocol RYSTAffirmationFilterViewDelegate <NSObject>

- (void)affirmationSelected:(RYSTAffirmation *)affirmation shouldUpdate:(BOOL)shouldUpdate;

@end

@interface RYSTAffirmationFilterView : UIView

- (instancetype)initWithFrame:(CGRect)frame affirmations:(NSArray *)affirmations;
@property (nonatomic, weak) id<RYSTAffirmationFilterViewDelegate> delegate;

@end
