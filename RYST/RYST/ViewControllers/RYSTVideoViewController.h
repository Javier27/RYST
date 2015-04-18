//
//  RYSTVideoViewController.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTBaseViewController.h"
@class RYSTAffirmation;

@interface RYSTVideoViewController : RYSTBaseViewController

// this maybe should be a protocol and I should be assigning this as a delegate
// pattern but leaving for now for simplicity, gets the job done
- (void)dismissChild:(UIViewController *)child animated:(BOOL)animated;
- (void)dismissAffirmationTable:(RYSTAffirmation *)affirmation;
- (void)dismissGallery;
- (void)dismissSaveVideoWithSave:(BOOL)shouldSave;

- (instancetype)initShouldDisplayIntro:(BOOL)shouldDisplayIntro;

@end
