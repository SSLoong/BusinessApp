//
//  GoodsWayCell.m
//  UsersApp
//
//  Created by perfect on 16/3/25.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import "GoodsWayCell.h"

@implementation GoodsWayCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}

-(void)initSubviews{

    _goodsLabel = [UILabel new];
    _goodsLabel.textColor = [UIColor lightGrayColor];
    _goodsLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_goodsLabel];
    
    _waysLabel = [UILabel new];
    _waysLabel.textColor = [UIColor blackColor];
    _waysLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_waysLabel];

}

-(void)setLayout{
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.and.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    [_waysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(-15);
    }];

}
@end
