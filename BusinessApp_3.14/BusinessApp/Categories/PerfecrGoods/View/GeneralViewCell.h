//
//  GeneralViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/5/4.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface GeneralViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *subLabel;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,strong)UILabel *priceLabel;

-(void)configModel:(OrderDetailModel *)model;

@end
