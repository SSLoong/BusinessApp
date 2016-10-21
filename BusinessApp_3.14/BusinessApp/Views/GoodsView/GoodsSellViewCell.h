//
//  GoodsSellViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsSellModel.h"

@interface GoodsSellViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *priceMoneyLabel;

@property(nonatomic,strong)UILabel *subsidyLabel;

@property(nonatomic,strong)UILabel *subsidyMoneyLabel;

@property(nonatomic,strong)UIButton *stateBtn;

-(void)configModel:(GoodsSellModel *)model;

@end
