//
//  RYSTPickAffirmationViewController.h
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYSTBaseTableViewController.h"
@class RYSTVideoViewController;

@interface RYSTPickAffirmationViewController : RYSTBaseTableViewController

@property (nonatomic, strong) RYSTVideoViewController *presenter;

- (id)initWithStyle:(UITableViewStyle)style
             parent:(RYSTVideoViewController *)parent;

@end
