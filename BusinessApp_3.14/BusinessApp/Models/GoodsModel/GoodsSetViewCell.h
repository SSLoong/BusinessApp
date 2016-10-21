//
//  GoodsSetViewCell.h
//  BusinessApp
//
//  Created by perfect on 16/4/3.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetModel.h"
@interface GoodsSetViewCell : UITableViewCell


@property(nonatomic,strong)UIImageView * logoImage;

@property(nonatomic,strong)UILabel * titleLabel;


@property(nonatomic,strong)UILabel * moneyLabel;

@property(nonatomic,strong)UILabel * cutLabel;

@property(nonatomic,strong)UILabel * cutMLabel;

@property(nonatomic,strong)UILabel * setLabel;

-(void)configModel:(SetModel *)model;
@end
