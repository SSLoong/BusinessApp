//
//  FansRewardModel.h
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/26.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansRewardModel : NSObject

@property (copy, nonatomic) NSString *memo;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *id;

@property (strong, nonatomic) NSArray *brands;

@property (copy, nonatomic) NSString *store_level;

@property (copy, nonatomic) NSString *platform_level;

@end
