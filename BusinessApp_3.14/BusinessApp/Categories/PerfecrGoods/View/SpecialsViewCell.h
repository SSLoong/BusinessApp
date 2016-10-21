//
//  SpecialsViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/6/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface SpecialsViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *subLabel;

@property(nonatomic,strong)UILabel *zengLabel;

@property(nonatomic,strong)UILabel *jianLabel;

@property(nonatomic,strong)UILabel *chooseLabel;

-(void)configModel:(GoodsModel *)model;

@end
