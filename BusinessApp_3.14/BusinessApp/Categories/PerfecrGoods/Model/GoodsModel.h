//
//  GoodsModel.h
//  BusinessApp
//
//  Created by prefect on 16/6/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property(nonatomic,copy)NSString *cover_img;

@property(nonatomic,copy)NSString *goods_name;

@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *goods_id;

@property(nonatomic,copy)NSString *sg_id;

@property(nonatomic,copy)NSString *sub_amount;

@property(nonatomic,assign)NSInteger orderCount;

@property(nonatomic,copy)NSString *type;

@end
