//
//  AppUtil.h
//  BusinessApp
//
//  Created by prefect on 16/3/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Util.h"
#import "UIView+Extension.h"

@class MBProgressHUD;

@interface AppUtil : NSObject


+(CGFloat)getScreenWidth;

+(CGFloat)getScreenHeight;

+ (BOOL)isNetworkExist;

+ (MBProgressHUD *)createHUD;

+(NSString *)getStartTime;

+(NSString *)getEndTime;

+(NSString *)getSystemTime;


/**
 *  获取app版本
 */

+(NSString *)getAppVersion;


/**
 *  获取手机系统版本
 */

+(NSString *)getOSVersion;


@end
