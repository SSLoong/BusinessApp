//
//  GoodsTableViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/4/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDataModel.h"


@interface GoodsTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * logoImage;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UILabel * priceLabel;

@property(nonatomic,strong)UILabel * priceMoneyLabel;

@property(nonatomic,strong)UILabel * deleLabel;

@property(nonatomic,strong)UILabel * deleMoneyLabel;

@property(nonatomic,strong)UIButton * applyBtn;

@property(nonatomic,strong)UILabel * statusLabel;

@property(nonatomic,strong)UILabel * saleLabel;

@property (nonatomic, strong) UILabel *purchaseLabel;

@property (nonatomic, strong) UIButton *purchaseBtn;

@property (nonatomic, strong) UIButton *sumBtn;

@property (nonatomic, strong) UIView *grayLine;

-(void)configModel:(GoodsDataModel *)model nowstatus:(NSInteger)nowstatus spetype:(NSInteger)spetype changeType:(NSString *)type;

@end
