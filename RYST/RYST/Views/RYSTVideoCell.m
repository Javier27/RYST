//
//  RYSTVideoCell.m
//  RYST
//
//  Created by Richie Davis on 4/17/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTAffirmation.h"
#import "RYSTVideoCell.h"
#import "RYSTVideo.h"
#import "UIView+RJDConvenience.h"

@interface RYSTVideoCell ()

@property (nonatomic, strong) UILabel *affirmationLabel;
@property (nonatomic, strong) UILabel *clickToWatch;

@end

@implementation RYSTVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _affirmationLabel = [[UILabel alloc] init];
    _affirmationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _affirmationLabel.font = [UIFont fontWithName:@"Avenir-Black" size:24.0f];
    _affirmationLabel.textColor = [UIColor darkGrayColor];
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

- (void)setVideo:(RYSTVideo *)video
{
  _video = video;
  self.affirmationLabel.text = video.affirmation.text;
}

@end
