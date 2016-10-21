//
//  RedDetailstCell.h
//  BusinessApp
//
//  Created by 孙升隆 on 16/9/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardListModel.h"
#import "InventoryListModel.h"
#import "IncomeDetailModel.h"
@interface RedDetailstCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *commentLabel;

-(void)configWithModel:(RewardListModel *)model type:(NSString *)type;

- (void)cofigModel:(InventoryListModel *)model;

- (void)cofigIncomeModel:(IncomeDetailModel *)model;


@end
