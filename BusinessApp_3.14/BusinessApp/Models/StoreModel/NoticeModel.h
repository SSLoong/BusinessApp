//
//  NoticeModel.h
//  BusinessApp
//
//  Created by perfect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * content;

@property(nonatomic,copy)NSString * type;

@property(nonatomic,copy)NSString * flag;

@property(nonatomic,copy)NSString  * create_time;

@property(nonatomic,copy)NSString * msg_id;

@property(nonatomic,copy)NSString * order_id;

@end
