//
//  ChooseViewController.h
//  BusinessApp
//
//  Created by prefect on 16/5/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelect)(NSString *special_id,NSString *sg_id,NSString *buy_num);

@interface ChooseViewController : UITableViewController

@property(nonatomic,copy)NSString *titleString;

@property(nonatomic,copy)NSString *goods_id;

@property(nonatomic,copy)didSelect didSelect;

@property(nonatomic,assign)NSInteger money;

@property(nonatomic,assign)NSInteger subMoney;

@end
