//
//  IncomeGoodsCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeGoodsModel.h"

@interface IncomeGoodsCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *numsLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *otherLabel;

-(void)configWithModel:(IncomeGoodsModel *)model;

@end
