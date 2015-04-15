//
//  RYSTVideoViewController.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTVideoViewController.h"
#import "RYSTIntroViewController.h"

@interface RYSTVideoViewController ()

@property (nonatomic, strong) RYSTIntroViewController *childViewController;

@end

@implementation RYSTVideoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor orangeColor];

  RYSTIntroViewController *vc = [[RYSTIntroViewController alloc] init];
  [self addChildViewController:vc];
  [self.view addSubview:vc.view];
  [vc didMoveToParentViewController:self];
  vc.presenter = self;

  _childViewController = vc;
}

- (void)dismissChild:(UIViewController *)child
{
  if (child == self.childViewController) {
    [UIView animateWithDuration:0.3f
                     animations:^{
                       self.childViewController.view.layer.transform = CATransform3DScale(CATransform3DIdentity,
                                                                                          0.01f,
                                                                                          0.01f,
                                                                                          1.0f);
                     } completion:^(BOOL finished) {
                       [self.childViewController willMoveToParentViewController:nil];
                       [self.childViewController.view removeFromSuperview];
                       [self.childViewController removeFromParentViewController];
                     }];
  } // abort if not
}

@end
