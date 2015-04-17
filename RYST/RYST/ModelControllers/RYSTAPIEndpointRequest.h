//
//  RYSTAPIEndpointRequest.h
//  RYST
//
//  Created by Richie Davis on 4/15/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYSTAPIEndpoint.h"

extern NSString *const kHeaderRYSTToken;

@class RKObjectRequestOperation, RYSTAPIClient;

typedef void (^RYSTMappingResultDelivery)(RKMappingResult *result, NSError *error);
typedef void (^RYSTAPIEndpointRequestExpiryHandler)(void);

@interface RYSTAPIEndpointRequest : NSObject

@property (nonatomic, weak) RYSTAPIClient *apiClient;
@property (nonatomic, readonly, copy) RYSTMappingResultDelivery completion;
@property (nonatomic, strong, readonly) RYSTAPIEndpoint *endpoint;

+ (RYSTAPIEndpointRequest *)requestWithEndpoint:(RYSTAPIEndpointName)endpointName
                                     pathSuffix:(NSString *)suffixOrNil
                                         params:(NSDictionary *)paramsOrNil
                                         object:(id)object
                                     completion:(RYSTMappingResultDelivery)deliveryOrNil;

- (RKObjectRequestOperation *)operation;

@end
