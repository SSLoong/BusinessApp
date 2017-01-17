//
//  AppUtil.m
//  BusinessApp
//
//  Created by prefect on 16/3/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AppUtil.h"
//#import <Reachability.h>
#import <MBProgressHUD.h>

@implementation AppUtil



+(CGFloat)getScreenHeight{

    return  [[UIScreen mainScreen] bounds].size.height;

}

+(CGFloat)getScreenWidth{
    
    return  [[UIScreen mainScreen] bounds].size.width;
    
}


+ (BOOL)isNetworkExist{
    
//    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://192.168.100.38"];
//    
//    return reachability.currentReachabilityStatus > 0;
    return YES;
}

+ (MBProgressHUD *)createHUD{
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    //[HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:HUD action:@selector(hide:)]];
    
    return HUD;
}


+(NSString *)getStartTime{

    NSString *endTime = [AppUtil getEndTime];
    
    //return [NSString stringWithFormat:@"%@01-01 00:00",[endTime substringToIndex:5]];
    return [NSString stringWithFormat:@"2016-01-01 00:00"];
}

+(NSString *)getEndTime{

    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}


+(NSString *)getSystemTime{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}


+(NSString *)getAppVersion{

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *)getOSVersion{

    return [[UIDevice currentDevice] systemVersion];

}



@end
