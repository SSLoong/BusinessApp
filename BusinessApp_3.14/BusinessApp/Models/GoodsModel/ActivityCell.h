//
//  ActivityCell.h
//  BusinessApp
//
//  Created by AlexChang on 16/9/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface ActivityCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *headerLabel;

@property(nonatomic,strong)UILabel *youhuiLabel;

@property(nonatomic,strong)UILabel *youhui1Label;

@property(nonatomic,strong)UILabel *statuLabel;

@property(nonatomic,strong)UILabel *jiangliLabel;

@property(nonatomic,strong)UILabel *isInLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)ActivityModel *model;

@end
