//
//  OrderDetailCell.m
//  UsersApp
//
//  Created by perfect on 16/3/25.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(OrderDetailModel *)model{
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_header"]];
    _nameLabel.text = model.goods_name;
    _priceLabel.text = @"售价:";
    _moneyOLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    _numLabel.text = [NSString stringWithFormat:@"×%@",model.buy_num];


}


-(void)initSubviews{
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor lightGrayColor];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLabel];
    
    _moneyOLabel = [UILabel new];
    _moneyOLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _moneyOLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_moneyOLabel];

    _numLabel = [UILabel new];
    _numLabel.textColor = [UIColor blackColor];
    _numLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numLabel];
}

-(void)setLayout{
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.and.left.mas_equalTo(15);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.left.equalTo(_logoImage.mas_right).offset(15);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(15.f);
        make.left.equalTo(_logoImage.mas_right).offset(15.f);
        make.height.mas_equalTo(14);
        
    }];
    [_moneyOLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_top);
        make.left.equalTo(_priceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(14);
    }];

    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(14);
    }];
}
@end
