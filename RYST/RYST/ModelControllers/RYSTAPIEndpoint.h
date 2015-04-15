//
//  RYSTAPIEndpoint.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef enum : NSInteger {
  RYSTAPIEndpointNameSignIn,
  RYSTAPIEndpointNameGetAffirmations,
  RYSTAPIEndpointNameAddVideo,
  RYSTAPIEndpointNameGetVideos,
  RYSTAPIEndpointNameUploadVideos
} RYSTAPIEndpointName;

@interface RYSTAPIEndpoint : NSObject

@property (nonatomic, assign) RKRequestMethod method;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSArray  *responseDescriptors;

+ (instancetype)endpointWithName:(RYSTAPIEndpointName)name;

@end
