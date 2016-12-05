//
//  GoodsStateModel.h
//  BusinessApp
//
//  Created by 孙升隆 on 2016/12/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsStateModel : NSObject
//名字
@property (nonatomic, copy) NSString *activity_name;
//活动类型
@property (nonatomic, copy) NSString *strategy;
//金额
@property (nonatomic, copy) NSString *sub_amount;
//
@property (nonatomic, copy) NSString *start_time;
//
@property (nonatomic, copy) NSString *end_time;
//推送人数
@property (nonatomic, copy) NSString *cust_num;

@property (nonatomic, copy) NSString *activity_id;

@end
