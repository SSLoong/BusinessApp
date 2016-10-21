//
//  WithdrawDetailCell.h
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/17.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryListModel.h"

@interface WithdrawDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UILabel *remarkLabel;

- (void)cofigModel:(InventoryListModel *)model;


@end
