//
//  MyBankViewController.h
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//
/**
 *  我的银行卡
 *  @author 孙升隆
 *  @version 3.1.3
 *  @since 3.1.2
 *  @date 2016-10-10
 */
#import <UIKit/UIKit.h>


typedef void(^bankString)(NSString *name,NSString *card,NSString *bank_id);

@interface MyBankViewController : UITableViewController

@property(nonatomic,copy)bankString bankString;

@property(nonatomic,copy)NSString *chooseBank;

@end
