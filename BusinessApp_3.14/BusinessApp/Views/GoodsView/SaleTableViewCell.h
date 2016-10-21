//
//  SaleTableViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleHeaderModel.h"

@interface SaleTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *addressLabel;

@property(nonatomic,strong)UILabel *headerLabel;

@property(nonatomic,strong)UIImageView *phoneImage;

@property(nonatomic,strong)UILabel *phoneLabel;

@property(nonatomic,strong)UIImageView *typeImage;

@property(nonatomic,strong)UILabel *typeLabel;

@property(nonatomic,strong)UILabel *statuLabel;

@property(nonatomic,strong)UIImageView *timeImage;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *bottomLine;

@property (nonatomic,copy) NSString *type;
-(void)configModel:(SaleHeaderModel *)model;

@end
