//
//  InventoryModel.h
//  BusinessApp
//
//  Created by prefect on 16/5/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryModel : NSObject

@property(nonatomic,strong)NSString *cover_img;

@property(nonatomic,strong)NSString *goods_id;

@property(nonatomic,strong)NSString *goods_name;

@property(nonatomic,strong)NSString *price;

@property(nonatomic,strong)NSString *total_stock;

@end
