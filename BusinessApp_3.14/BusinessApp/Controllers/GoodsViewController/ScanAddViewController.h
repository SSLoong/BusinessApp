//
//  ScanAddViewController.h
//  BusinessApp
//
//  Created by prefect on 16/6/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//  扫码

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanAddViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@property (nonatomic, assign) BOOL isPlural;//是否可以多次扫描;


@end
