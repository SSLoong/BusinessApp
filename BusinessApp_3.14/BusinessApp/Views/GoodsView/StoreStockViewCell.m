//
//  StoreStockViewCell.m
//  UserApp
//
//  Created by perfect on 16/5/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreStockViewCell.h"

@implementation StoreStockViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(InventoryModel *)model{

    [_storeImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_header"]];
    
    _titleLabel.text = model.goods_name;

    _numLabel.text = [NSString stringWithFormat:@"%@",model.total_stock];
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];

}


-(void)initSubviews{
    
    _storeImage = [UIImageView new];
    [self.contentView addSubview:_storeImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.text = @"售价:";
    _priceLabel.textColor = [UIColor lightGrayColor];
    _priceLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_priceLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_moneyLabel];
    
    _kucunLabel = [UILabel new];
    _kucunLabel.text = @"库存:";
    _kucunLabel.textColor = [UIColor lightGrayColor];
    _kucunLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_kucunLabel];
    
    _numLabel = [UILabel new];
    _numLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _numLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_numLabel];
}

-(void)setLayout{

    [_storeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(65);
        make.height.mas_equalTo(14);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.left.mas_equalTo(65);
        make.height.mas_equalTo(13);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.left.mas_equalTo(100);
        make.height.mas_equalTo(13);
    }];
    [_kucunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.left.mas_equalTo(160);
        make.height.mas_equalTo(13);
    }];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.left.equalTo(_kucunLabel.mas_right).offset(2.f);
        make.height.mas_equalTo(13);
    }];
}

@end
