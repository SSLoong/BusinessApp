//
//  OpenTicketViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsModel.h"

@interface OpenTicketViewCell : UITableViewCell


@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIImageView *chooseImage;


-(void)configModel:(LogisticsModel *)model;

@end
