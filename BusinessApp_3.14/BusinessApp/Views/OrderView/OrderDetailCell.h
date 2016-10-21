//
//  OrderDetailCell.h
//  UsersApp
//
//  Created by perfect on 16/3/25.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderDetailCell : UITableViewCell

@property(nonatomic,strong)UIImageView * logoImage;

@property(nonatomic,strong)UILabel * nameLabel;
//售价
@property(nonatomic,strong)UILabel * priceLabel;

@property(nonatomic,strong)UILabel * moneyOLabel;

@property(nonatomic,strong)UILabel * numLabel;

-(void)configModel:(OrderDetailModel *)model;


@end
