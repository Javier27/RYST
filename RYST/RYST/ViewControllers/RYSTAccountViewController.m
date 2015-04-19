//
//  RYSTAccountViewController.m
//  RYST
//
//  Created by Richie Davis on 4/18/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAccountViewController.h"
#import "RYSTEnvironment.h"
#import "RYSTSessionController.h"
#import "RYSTVideoViewController.h"
#import "RYSTVideoGalleryViewController.h"

static const CGFloat kButtonWidth = 200;
static const CGFloat kButtonHeight = 35;
static const CGFloat kButtonSeparation = 20;

@implementation RYSTAccountViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor colorWithRed:(111.0/255.0) green:(168.0/255.0) blue:(255.0/255.0) alpha:1.0];

  UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
  accountImageView.image = [UIImage imageNamed:@"user-yellow"];
  accountImageView.center = CGPointMake(self.view.center.x, 60);
  [self.view addSubview:accountImageView];

  UILabel *myAccountLabel = [[UILabel alloc] init];
  myAccountLabel.text = NSLocalizedString(@"My Account", nil);
  myAccountLabel.textColor = [UIColor whiteColor];
  myAccountLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:32.0f];
  [myAccountLabel sizeToFit];
  myAccountLabel.center = CGPointMake(self.view.center.x, 130);
  [self.view addSubview:myAccountLabel];

  UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
  videoButton.center = CGPointMake(self.view.center.x, self.view.center.y);
  [self stylePrimaryButton:videoButton
                     color:[UIColor colorWithRed:(253.0/255.0) green:(168.0/255.0) blue:(171.0/255.0) alpha:1.0]
                     title:NSLocalizedString(@"Video Gallery", nil)
                    action:@selector(presentVideoGallery)];

  UIButton *signOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
  signOutButton.center = CGPointMake(self.view.center.x, self.view.center.y + kButtonSeparation + kButtonHeight);
  [self stylePrimaryButton:signOutButton
                     color:[UIColor colorWithRed:(211.0/255.0) green:(105.0/255.0) blue:(108.0/255.0) alpha:1.0]
                     title:NSLocalizedString(@"Sign Out", nil)
                    action:@selector(signOut)];

  UIButton *resetAppButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
  resetAppButton.center = CGPointMake(self.view.center.x, self.view.center.y + 2 * (kButtonSeparation + kButtonHeight));
  [self stylePrimaryButton:resetAppButton
                     color:[UIColor colorWithRed:(126.0/255.0) green:(21.0/255.0) blue:(24.0/255.0) alpha:1.0]
                     title:NSLocalizedString(@"Reset App", nil)
                    action:@selector(resetApp)];

  UIButton *backButtonContainer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
  [backButtonContainer addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];

  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 25, 20)];
  [backButton setBackgroundImage:[UIImage imageNamed:@"Left"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
  [backButtonContainer addSubview:backButton];

  [self.view addSubview:backButtonContainer];
}

- (void)stylePrimaryButton:(UIButton *)button color:(UIColor *)color title:(NSString *)title action:(SEL)action
{
  [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
  button.backgroundColor = color;
  [button setTitle:title forState:UIControlStateNormal];
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  button.layer.cornerRadius = 8.0f;
  [self.view addSubview:button];
}

- (void)presentVideoGallery
{
  RYSTVideoGalleryViewController *vc = [[RYSTVideoGalleryViewController alloc] init];
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)signOut
{
  [[RYSTSessionController sessionController] signOut];
  [self.presenter signOut];
}

- (void)resetApp
{
  [[RYSTSessionController sessionController] resetApp];
  [self signOut];
}

- (void)exit
{
  [self.presenter dismissAccount];
}

@end
