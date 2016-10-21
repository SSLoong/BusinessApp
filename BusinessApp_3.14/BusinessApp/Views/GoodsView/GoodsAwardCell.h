//
//  GoodsAwardCell.h
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/17.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesAwardModel.h"
@interface GoodsAwardCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodsImg;

@property (nonatomic, strong) UILabel *goodsName;

@property (nonatomic, strong) UILabel *haveSaleLabel;

@property (nonatomic, strong) UILabel *surplusLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *awardLabe;;

- (void)configSalesAwardModel:(SalesAwardModel *)model;


@end
