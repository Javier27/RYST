//
//  RYSTAffirmationCell.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmationCell.h"
#import "RYSTAffirmation.h"
#import "UIView+RJDConvenience.h"

@interface RYSTAffirmationCell ()

@property (nonatomic, strong) UILabel *affirmationLabel;

@end

@implementation RYSTAffirmationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _affirmationLabel = [[UILabel alloc] init];
    _affirmationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _affirmationLabel.font = [UIFont fontWithName:@"Avenir-Black" size:24.0f];
    _affirmationLabel.textColor = [UIColor whiteColor];
    _affirmationLabel.center = self.center;
    _affirmationLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_affirmationLabel];

    [self convenientConstraintsWithVisualFormats:@[@"V:|[label]|", @"H:|[label]|"]
                                         options:0
                                         metrics:nil
                                        children:@{ @"label" : _affirmationLabel }];
  }

  return self;
}

- (void)setAffirmation:(RYSTAffirmation *)affirmation
{
  _affirmation = affirmation;
  self.affirmationLabel.text = affirmation.text;
}

@end
