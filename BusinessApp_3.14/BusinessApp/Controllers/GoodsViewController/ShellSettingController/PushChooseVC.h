//
//  PushChooseVC.h
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushChooseVC : UIViewController

@property (nonatomic, copy) NSString *store_goods_id;

@property (nonatomic, copy) void(^chooseBtnBlock)(NSArray *scustidArr);

@property (nonatomic, copy) void(^allChooseBtnBlock)(NSArray *scustidArr);

@end
