//
//  OpreationViewCell.h
//  BusinessApp
//
//  Created by perfect on 16/3/30.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MangerModel.h"
@interface OpreationViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * nameLabel;

@property(nonatomic,strong)UILabel * phoneLabel;

@property(nonatomic,strong)UISwitch * oneSwitch;

-(void)configModel:(MangerModel*)model;
@end
