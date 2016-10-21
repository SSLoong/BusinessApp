//
//  IncomeDetailModel.h
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeDetailModel : NSObject

@property(nonatomic,copy,setter=setId:)NSString *order_id;

@property(nonatomic,copy)NSString *create_time;

@property (nonatomic, copy) NSNumber *amount;

@property (nonatomic, copy) NSString *memo;

@property (nonatomic, copy) NSString *type;

@end



@interface orderdetails : NSObject

@property(nonatomic,copy)NSString *goodsname;

@property(nonatomic,copy)NSString *buy_num;

@end
