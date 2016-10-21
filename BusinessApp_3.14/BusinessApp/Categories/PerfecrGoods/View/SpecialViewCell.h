//
//  SpecialViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/5/6.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "specialModel.h"

@interface SpecialViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *strategyLabel;

@property(nonatomic,strong)UILabel *titleLabel;

-(void)configModel:(specialModel *)model;


@end
