//
//  GoodsMesCell.h
//  BusinessApp
//
//  Created by perfect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftsModel.h"

@interface GoodsMesCell : UITableViewCell

@property(nonatomic,strong)UIView *topLine;

@property(nonatomic,strong)UIImageView * logoImage;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UILabel * moneyLabel;

@property(nonatomic,strong)UILabel * deleLabel;

@property(nonatomic,strong)UILabel * numLabel;

-(void)configModel:(GiftsModel *)model;

@end
