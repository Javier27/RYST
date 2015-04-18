//
//  RYSTUploadResponse.m
//  RYST
//
//  Created by Richie Davis on 4/14/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTUploadResponse.h"

@implementation RYSTUploadResponse

+ (instancetype)objectFromJSONData:(NSData *)data
{
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  RYSTUploadResponse *response = [[RYSTUploadResponse alloc] init];
  for (NSString *key in dictionary) {
    id object = dictionary[key];
    if ([key isEqualToString:@"class"]) {
      response.classString = object;
    } else if ([key isEqualToString:@"id"]) {
      response.identifier = object;
    } else if ([key isEqualToString:@"media_type"]) {
      response.mediaTypeString = object;
    } else if ([key isEqualToString:@"url"]) {
      response.url = object;
    }
  }

  return response;
}

@end
