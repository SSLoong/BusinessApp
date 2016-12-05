//
//  PushChooseModel.h
//  BusinessApp
//
//  Created by 孙升隆 on 2016/12/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushChooseModel : NSObject

@property (nonatomic) BOOL isSelected;

@property (nonatomic, copy) NSString *buy_num;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *platform_level;
@property (nonatomic, copy) NSString *store_level;

@end
