//
//  InventoryListCell.h
//  BusinessApp
//
//  Created by perfect on 16/3/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryListModel.h"


@interface InventoryListCell : UITableViewCell

@property(nonatomic,strong)UIImageView * logoImage;

@property(nonatomic,strong)UILabel * moneyLabel;

@property(nonatomic,strong)UILabel * setLabel;

@property(nonatomic,strong)UILabel * timeLabel;

-(void)cofigModel:(InventoryListModel *)model;

@end
