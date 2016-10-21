//
//  AllGoodsModel.h
//  BusinessApp
//
//  Created by prefect on 16/3/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllGoodsModel : NSObject

@property(nonatomic,copy,setter=setId:)NSString *sId;

@property(nonatomic,copy)NSArray *brandlist;

@property(nonatomic,copy)NSString *name;

@end

@interface BrandlistModel : NSObject

@property(nonatomic,copy,setter=setId:)NSString *sId;

@property(nonatomic,copy)NSString *logo;

@end
