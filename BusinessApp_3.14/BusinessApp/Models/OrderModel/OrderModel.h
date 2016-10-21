//
//  OrderModel.h
//  BusinessApp
//
//  Created by prefect on 16/3/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property(nonatomic,copy,setter=setId:)NSString *sId;

@property(nonatomic,copy)NSString *create_time;

@property(nonatomic,strong)NSArray *goodsimgls;

@property(nonatomic,copy)NSString *pay_result;

@property(nonatomic,copy)NSString *phone;

@property(nonatomic,copy)NSString *real_amount;

@property(nonatomic,copy)NSString *receive_type;

@property(nonatomic,copy)NSString *should_amount;

@property(nonatomic,copy)NSString *status;

@property(nonatomic,copy)NSString *total_subsidy;

@property(nonatomic,copy)NSString *total_goods;


@end
