//
//  IncomeDetailCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeDetailModel.h"

@interface IncomeDetailCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *moneyLabel;

@property(nonatomic,strong)UILabel *dataLabel;

-(void)configModel:(IncomeDetailModel *)model row:(NSInteger)row;

+(CGFloat)getHightWinthModel:(IncomeDetailModel *)model;

+(NSInteger)getRowsWithModel:(IncomeDetailModel *)model;

@end
