//
//  AddBankViewController.h
//  BusinessApp
//
//  Created by prefect on 16/3/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//
/**
 *  添加银行卡
 *  @author 孙升隆
 *  @version 3.1.3
 *  @since 3.1.2
 *  @date 2016-10-10
 */
#import <UIKit/UIKit.h>
#import "BankListModel.h"

typedef void(^addSuccess)();

@interface AddBankViewController : UITableViewController

@property(nonatomic,copy)addSuccess addSuccess;

@property (nonatomic, strong) BankListModel *modle;

@end
