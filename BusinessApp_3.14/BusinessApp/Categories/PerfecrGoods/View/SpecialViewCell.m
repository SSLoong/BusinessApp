//
//  SpecialViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/5/6.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpecialViewCell.h"

@implementation SpecialViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}



-(void)configModel:(specialModel *)model{
    
    NSArray * goodses = model.goodses;
    
    NSDictionary *dic = [goodses firstObject];
    
    _nameLabel.text = dic[@"goods_name"];
    
    _numLabel.text = [NSString stringWithFormat:@"×%@",dic[@"buy_num"]];
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",dic[@"price"]];
    
    NSDictionary *dict1 = model.marketing;
    
    if ([model.mk_strategy integerValue] == 1) {
        
        _strategyLabel.text = [NSString stringWithFormat:@"立减%@元",dic[@"special_subamount"]];
        _titleLabel.text = nil;
        
    }else if ([model.mk_strategy integerValue] == 2){
    
        _strategyLabel.text = @"减";
        
        _titleLabel.text = model.strategy;
    
    
    }else if ([model.mk_strategy integerValue] == 3){
        
        NSArray *gift_goods = dict1[@"gift_goods"];
        
        NSDictionary *dict2 = [gift_goods firstObject];
        
        _strategyLabel.text = @"赠";
        
        _titleLabel.text =[NSString stringWithFormat:@"%@:%@",model.strategy,dict2[@"goods_name"]];
    
    }
    
    


}

-(void)initSubviews{
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLabel];
    
    _strategyLabel = [UILabel new];
    _strategyLabel.font = [UIFont systemFontOfSize:13];
    _strategyLabel.textColor = [UIColor whiteColor];
    _strategyLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _strategyLabel.layer.cornerRadius = 2.f;
    _strategyLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_strategyLabel];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_titleLabel];

}


-(void)setLayout{
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(14);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.equalTo(_priceLabel.mas_left).offset(-10.f);
        make.height.mas_equalTo(14);
    }];
    
    
    [_strategyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_strategyLabel.mas_right).offset(3.f);
        make.height.mas_equalTo(14);
    }];
    

}


@end
