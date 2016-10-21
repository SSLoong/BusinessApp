//
//  DateSiftViewController.h
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//
/**
 *  日期筛选
 *  @author 孙升隆
 *  @version 3.1.3
 *  @since 3.1.2
 *  @date 2016-10-10
 */
#import <UIKit/UIKit.h>

@interface DateSiftViewController : UIViewController

@property (nonatomic, copy) void(^sureBtnBlock)(NSString *startTime,NSString *endTime);


@end
