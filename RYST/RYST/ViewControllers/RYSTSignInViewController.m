//
//  RYSTSignInViewController.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTSignInViewController.h"
#import "RYSTSessionController.h"
#import "RYSTEnvironment.h"
#import "RYSTIntroViewController.h"
#import "RYSTVideoViewController.h"
#import "UIView+RJDConvenience.h"

@interface RYSTSignInViewController ()

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UIButton *usernameSubmitButton;
@property (nonatomic) BOOL hasEverSignedIn;

@end

@implementation RYSTSignInViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor colorWithRed:(111.0/255.0) green:(168.0/255.0) blue:(255.0/255.0) alpha:1.0];

  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  titleLabel.textColor = [UIColor whiteColor];
  titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:55.0f];
  titleLabel.text = @"RYST"; // need not localize as title is ubiquitous
  [self.view addSubview:titleLabel];

  _usernameTextField = [[UITextField alloc] init];
  _usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
  _usernameTextField.backgroundColor = [UIColor colorWithRed:(235.0/255.0) green:(46.0/255.0) blue:(81.0/255.0) alpha:1.0];
  _usernameTextField.textColor = [UIColor whiteColor];
  _usernameTextField.font = [UIFont fontWithName:@"Avenir-Heavy" size:18.0f];
  NSString *placeholder = NSLocalizedString(@"Username", @"username placeholder text");
  NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
  _usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                             attributes:attributes];
  // add padding
  UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
  _usernameTextField.leftView = paddingView;
  _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
  [self.view addSubview:_usernameTextField];

  _usernameSubmitButton = [[UIButton alloc] init];
  _usernameSubmitButton.translatesAutoresizingMaskIntoConstraints = NO;
  _usernameSubmitButton.backgroundColor = [UIColor colorWithRed:(235.0/255.0) green:(46.0/255.0) blue:(81.0/255.0) alpha:1.0];
  [_usernameSubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_usernameSubmitButton setTitle:NSLocalizedString(@"Sign In", @"title for sign in button") forState:UIControlStateNormal];
  _usernameSubmitButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];
  [_usernameSubmitButton addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_usernameSubmitButton];

  [self.view centerChildrenHorizontally:@[titleLabel, _usernameTextField, _usernameSubmitButton]];
  [self.view convenientConstraintsWithVisualFormats:@[ @"V:|-50-[view1]-60-[view2(30)]-15-[view3]",
                                                       @"H:[view2(190)]",
                                                       @"H:[view3(80)]" ]
                                            options:0
                                            metrics:nil
                                           children:@{ @"view1" : titleLabel,
                                                       @"view2" : _usernameTextField,
                                                       @"view3" : _usernameSubmitButton }];
}

- (void)signIn
{

//  self.hasEverSignedIn = RYSTUserDefaultsGetHasEverSignedIn();
//  RYSTUserDefaultsSetHasEverSignedIn(YES);

  if (self.hasEverSignedIn) {

  } else {

  }

  RYSTVideoViewController *mainVC = [[RYSTVideoViewController alloc] init];
  [self presentViewController:mainVC animated:YES completion:nil];

  //  if (self.usernameTextField.text.length > 0) {
  //    // make request, all requests of this nature should go through the session controller
  //    // so that I am able to let the session controller handle all session related details
  //    self.hasEverSignedIn = RYSTUserDefaultsGetHasEverSignedIn();
  //    [[RYSTSessionController sessionController] signInWithEmail:self.usernameTextField.text
  //                                               completionOrNil:^(RYSTToken *result, NSError *error) {
  //                                                 if (result) {
  //                                                   if (self.hasEverSignedIn) {
  //                                                     // take to onboarding
  //                                                   } else {
  //                                                     // take to another screen
  //                                                   }
  //                                                 } else {
  //                                                   // show error message
  //                                                 }
  //                                               }];
  //  } else {
  //    // show error message
  //  }
}

@end
