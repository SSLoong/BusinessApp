//
//  ChooseCustomerCell.h
//  BusinessApp
//
//  Created by wangyebin on 16/9/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCustomerCell : UITableViewCell

@property (strong, nonatomic) NSDictionary * dataDic;//数据
@property (nonatomic, copy) void (^buttonBlock)(NSString * name,NSString * phone);

@end
