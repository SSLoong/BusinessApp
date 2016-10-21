//
//  OrderPayViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderPayViewCell.h"

@implementation OrderPayViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}


-(void)initSubviews{
    
    
    _gongjiLabel = [UILabel new];
    _gongjiLabel.textColor = [UIColor lightGrayColor];
    _gongjiLabel.font= [UIFont systemFontOfSize:14.f];
    _gongjiLabel.text = @"共计";
    [self.contentView addSubview:_gongjiLabel];
    
    _goodsNumLabel = [UILabel new];
    _goodsNumLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _goodsNumLabel.font= [UIFont systemFontOfSize:14.f];
    _goodsNumLabel.text = @"0";
    [self.contentView addSubview:_goodsNumLabel];
    
    _goodsLabel = [UILabel new];
    _goodsLabel.textColor = [UIColor lightGrayColor];
    _goodsLabel.font= [UIFont systemFontOfSize:14.f];
    _goodsLabel.text = @"件商品";
    [self.contentView addSubview:_goodsLabel];
    
    
    _butieLabel = [UILabel new];
    _butieLabel.textColor = [UIColor lightGrayColor];
    _butieLabel.font= [UIFont systemFontOfSize:14.f];
    _butieLabel.textAlignment = NSTextAlignmentCenter;
    _butieLabel.text = @"奖励:";
    [self.contentView addSubview:_butieLabel];
    
    
    _butieMoneyLabel = [UILabel new];
    _butieMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _butieMoneyLabel.font= [UIFont systemFontOfSize:14.f];
    _butieMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _butieMoneyLabel.text = @"¥0.00";
    [self.contentView addSubview:_butieMoneyLabel];
    
    
    _shifuLabel = [UILabel new];
    _shifuLabel.textColor = [UIColor lightGrayColor];
    _shifuLabel.font= [UIFont systemFontOfSize:14.f];
    _shifuLabel.textAlignment = NSTextAlignmentCenter;
    _shifuLabel.text = @"实付:";
    [self.contentView addSubview:_shifuLabel];
    
    
    _shifuMoneyLabel = [UILabel new];
    _shifuMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _shifuMoneyLabel.font= [UIFont systemFontOfSize:14.f];
    _shifuMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _shifuMoneyLabel.text = @"¥0.00";
    [self.contentView addSubview:_shifuMoneyLabel];
    
}


-(void)setLayout{
    

    [_gongjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_goodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_gongjiLabel.mas_right).offset(1.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_goodsNumLabel.mas_right).offset(1.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    
    [_shifuMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_shifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_shifuMoneyLabel.mas_left).offset(-5.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_butieMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_shifuLabel.mas_left).offset(-8.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_butieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_butieMoneyLabel.mas_left).offset(-5.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    
}





@end
