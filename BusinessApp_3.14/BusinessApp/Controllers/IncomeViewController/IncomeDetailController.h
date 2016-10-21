//
//  IncomeDetailController.h
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//
/**
 *  收入统计
 *  @author 孙升隆
 *  @version 3.1.3
 *  @since 3.1.2
 *  @date 2016-10-10
 */
#import <UIKit/UIKit.h>

@interface IncomeDetailController : UIViewController

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,copy)NSString *startTime;//开始时间

@property(nonatomic,copy)NSString *endTime;//结束时间

@property(nonatomic,strong)UITableView *tbView;


@end
