//
//  InventoryCell.h
//  TestTest
//
//  Created by perfect on 16/3/29.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

@interface InventoryCell : UITableViewCell

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UILabel * numLabel;

@property(nonatomic,strong)UILabel * priceLabel;

@property(nonatomic,strong)UILabel * moneyLabel;

@property(nonatomic,strong)UILabel * headLabel;
//小计
@property(nonatomic,strong)UILabel * totalLabel;
//总价
@property(nonatomic,strong)UILabel * aggregateLabel;

-(void)configModel:(GoodsDetailModel *)model;

@end
