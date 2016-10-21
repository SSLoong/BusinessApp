//
//  GoodsViewCell.h
//  UserApp
//
//  Created by prefect on 16/4/20.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

typedef void(^addBlock)(BOOL isAdd);

@interface GoodsViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *subLabel;

@property(nonatomic,strong)UIButton *minus;

@property(nonatomic,strong)UIButton *plus;

@property(nonatomic,strong)UILabel *countLabel;

@property (nonatomic,copy)addBlock addBlock;

-(void)configModel:(GoodsModel *)model;

@end
