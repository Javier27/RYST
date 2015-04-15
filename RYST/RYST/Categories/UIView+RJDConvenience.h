//
//  UIView+RJDConvenience.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
  RJDConvenienceTypeCenter,
  RJDConvenienceTypeCenterHorizontal,
  RJDConvenienceTypeCenterVertical,
  RJDConvenienceTypeEqualWidth,
  RJDConvenienceTypeEqualHeight,
} RJDConvenienceType;

@interface UIView (RJDConvenience)

- (void)convenientConstraintsWithVisualFormats:(NSArray *)visualFormats
                                       options:(NSInteger)options
                                       metrics:(NSDictionary *)metrics
                                      children:(NSDictionary *)children;

- (void)applyLayoutsToChildren:(NSArray *)children layouts:(NSArray *)layouts;
- (void)centerChildren:(NSArray *)children;
- (void)centerChildrenHorizontally:(NSArray *)children;
- (void)centerChildrenVertically:(NSArray *)children;
- (void)matchChildrenToWidth:(NSArray *)children;
- (void)matchChildrenToHeight:(NSArray *)children;

@end
