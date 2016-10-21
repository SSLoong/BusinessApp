//
//  ChooseCustomerVC.h
//  BusinessApp
//
//  Created by wangyebin on 16/9/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCustomerVC : UIViewController

@property (nonatomic, copy) void (^changeBlock)(NSString *name,NSString * phone);//回调Block,把值传给上个控制器

@end
