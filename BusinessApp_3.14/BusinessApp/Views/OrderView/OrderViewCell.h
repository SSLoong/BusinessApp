//
//  OrderViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderViewCell : UITableViewCell


@property(nonatomic,strong)UIImageView *stateImage;

@property(nonatomic,strong)UILabel *phoneLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIImageView *goodsImage1;

@property(nonatomic,strong)UIImageView *goodsImage2;

@property(nonatomic,strong)UIImageView *goodsImage3;

@property(nonatomic,strong)UIImageView *moreImage;

@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong)UILabel *payLabel;

@property(nonatomic,strong)UILabel *deliveryLabel;

@property(nonatomic,strong)UILabel *gongjiLabel;

@property(nonatomic,strong)UILabel *goodsNumLabel;

@property(nonatomic,strong)UILabel *goodsLabel;

@property(nonatomic,strong)UILabel *butieLabel;

@property(nonatomic,strong)UILabel *butieMoneyLabel;

@property(nonatomic,strong)UILabel *shifuLabel;

@property(nonatomic,strong)UILabel *shifuMoneyLabel;

-(void)configWithModel:(OrderModel *)model type:(NSInteger)type;


@end
