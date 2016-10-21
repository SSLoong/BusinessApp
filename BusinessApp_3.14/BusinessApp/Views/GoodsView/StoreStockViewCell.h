//
//  StoreStockViewCell.h
//  UserApp
//
//  Created by perfect on 16/5/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryModel.h"


@interface StoreStockViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * storeImage;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UILabel * priceLabel;

@property(nonatomic,strong)UILabel * moneyLabel;

@property(nonatomic,strong)UILabel * kucunLabel;

@property(nonatomic,strong)UILabel * numLabel;

-(void)configModel:(InventoryModel *)model;

@end
