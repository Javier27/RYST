//
//  UILabel+FSHighlightAnimationAdditions.m
//  RYST
//
//  Created by Richie Davis on 4/17/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "UILabel+FSHighlightAnimationAdditions.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (FSHighlightAnimationAdditions)

- (void)setTextWithChangeAnimation:(NSString*)text
{
  NSLog(@"value changing");
  self.text = text;
  CALayer *maskLayer = [CALayer layer];

  maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f] CGColor];
  maskLayer.contents = (id)[[UIImage imageNamed:@"Mask.png"] CGImage];
  maskLayer.contentsGravity = kCAGravityCenter;
  maskLayer.frame = CGRectMake(self.frame.size.width * -1, 0.0f, self.frame.size.width * 2, self.frame.size.height);

  CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
  maskAnim.byValue = [NSNumber numberWithFloat:self.frame.size.width];
  maskAnim.repeatCount = FLT_MAX;
  maskAnim.duration = 2.0f;
  [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];

  self.layer.mask = maskLayer;
}

@end
