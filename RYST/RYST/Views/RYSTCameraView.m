//
//  RYSTCameraView.m
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import "RYSTCameraView.h"
#import <AVFoundation/AVFoundation.h>

@implementation RYSTCameraView

+ (Class)layerClass
{
  return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
  return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
  [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
