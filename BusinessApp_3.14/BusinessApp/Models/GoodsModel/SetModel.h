//
//  SetModel.h
//  BusinessApp
//
//  Created by perfect on 16/4/3.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetModel : NSObject

@property(nonatomic,copy)NSString * goods_name;

@property(nonatomic,copy)NSString * price;//价格

@property(nonatomic,copy)NSString * sub_amount;//立减金额

@property(nonatomic,copy)NSString * store_goods_id;

@property(nonatomic,copy)NSString *  cover_img;

@property(nonatomic,copy)NSString *  recommend;
@end
