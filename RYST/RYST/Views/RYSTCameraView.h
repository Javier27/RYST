//
//  RYSTCameraView.h
//  RYST
//
//  Created by Richie Davis on 4/16/15.
//  Copyright (c) 2015 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;

@interface RYSTCameraView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
