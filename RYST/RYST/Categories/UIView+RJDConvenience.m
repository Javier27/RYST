//
//  UIView+RJDConvenience.m
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "UIView+RJDConvenience.h"

@implementation UIView (RJDConvenience)

- (void)convenientConstraintsWithVisualFormats:(NSArray *)visualFormats
                                       options:(NSInteger)options
                                       metrics:(NSDictionary *)metrics
                                      children:(NSDictionary *)children
{
  for (NSString *visualFormat in visualFormats) {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                 options:options
                                                                 metrics:metrics
                                                                   views:children]];
  }
}

- (void)applyLayoutsToChildren:(NSArray *)children layouts:(NSArray *)layouts;
{
  for (NSInteger i = 0; i < children.count; i++) {
    UIView *child = children[i];
    RJDConvenienceType layoutType = ((NSNumber *)layouts[i]).integerValue;
    switch (layoutType) {
      case RJDConvenienceTypeCenter:
        [self centerChildren:@[child]];
        break;
      case RJDConvenienceTypeCenterHorizontal:
        [self centerChildrenHorizontally:@[child]];
        break;
      case RJDConvenienceTypeCenterVertical:
        [self centerChildrenVertically:@[child]];
        break;
      case RJDConvenienceTypeEqualWidth:
        [self matchChildrenToWidth:@[child]];
        break;
      case RJDConvenienceTypeEqualHeight:
        [self matchChildrenToHeight:@[child]];
        break;
      default:
        break;
    }
  }
}

- (void)centerChildren:(NSArray *)children
{
  [self centerChildrenHorizontally:children];
  [self centerChildrenVertically:children];
}

- (void)centerChildrenHorizontally:(NSArray *)children
{
  for (UIView *child in children) {
    [self setAttribute:NSLayoutAttributeCenterX equalOnChild:child];
  }
}

- (void)centerChildrenVertically:(NSArray *)children
{
  for (UIView *child in children) {
    [self setAttribute:NSLayoutAttributeCenterY equalOnChild:child];
  }
}

- (void)matchChildrenToWidth:(NSArray *)children
{
  for (UIView *child in children) {
    [self setAttribute:NSLayoutAttributeWidth equalOnChild:child];
  }
}

- (void)matchChildrenToHeight:(NSArray *)children
{
  for (UIView *child in children) {
    [self setAttribute:NSLayoutAttributeHeight equalOnChild:child];
  }
}

- (void)setAttribute:(NSLayoutAttribute)attribute equalOnChild:(UIView *)child
{
  [self addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                   attribute:attribute
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:attribute
                                                  multiplier:1.0f
                                                    constant:0.0f]];
}

@end
