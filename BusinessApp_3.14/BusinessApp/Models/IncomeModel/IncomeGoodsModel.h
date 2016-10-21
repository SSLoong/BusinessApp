//
//  IncomeGoodsModel.h
//  BusinessApp
//
//  Created by prefect on 16/3/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeGoodsModel : NSObject

@property(nonatomic,copy,setter=setId:)NSString *sId;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *sumamount;

@property(nonatomic,copy)NSString *nums;

@property(nonatomic,copy)NSString *cover_img;

@end
