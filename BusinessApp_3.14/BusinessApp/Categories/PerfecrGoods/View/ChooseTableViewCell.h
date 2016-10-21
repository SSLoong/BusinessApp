//
//  ChooseTableViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/5/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseModel.h"

typedef void(^plusBlock)(NSInteger count,BOOL animated);

@interface ChooseTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *strategyLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *goodsNameLabel;



@property(nonatomic,strong)UIButton *minus;

@property(nonatomic,strong)UIButton *plus;

@property(nonatomic,strong)UILabel *orderCount;

@property (nonatomic,assign) NSUInteger amount;

@property (nonatomic,copy)plusBlock plusBlock;


-(void)configModel:(ChooseModel *)model;

+(CGFloat)getHightWinthModel:(ChooseModel *)model;

@end
