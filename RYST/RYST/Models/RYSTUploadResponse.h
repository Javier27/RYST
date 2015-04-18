//
//  RYSTUploadResponse.h
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYSTUploadResponse : NSObject

@property (nonatomic, copy) NSString *classString;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, copy) NSString *mediaTypeString;
@property (nonatomic, copy) NSString *url;

+ (instancetype)objectFromJSONData:(NSData *)data;

@end
