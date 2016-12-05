//
//  GoodsSetViewCell.m
//  BusinessApp
//
//  Created by perfect on 16/4/3.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsSetViewCell.h"

@implementation GoodsSetViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubview];
        [self setLayout];
    }
    return self;
}


-(void)configModel:(SetModel *)model{
    
    _titleLabel.text = model.goods_name;
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    if ([model.sub_amount integerValue] == 0) {
        
        _cutLabel.text = nil;
        _cutMLabel.text = nil;
        
    }else{
    
        _cutLabel.text = nil;
        _cutMLabel.text = nil;

//        _cutLabel.text = @"立减";
//        _cutMLabel.text = [NSString stringWithFormat:@"%@元",model.sub_amount];
    }

    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_header"]];
    
    if ([model.recommend integerValue] == 0 ) {
        _setLabel.text = nil;
    }else{
        _setLabel.text = nil;
        //_setLabel.text = @"已推荐";
        //_setLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    }
}
-(void)initSubview{
    
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    _setLabel = [UILabel new];
    _setLabel.font = [UIFont systemFontOfSize:14];
    _setLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_setLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_moneyLabel];
    
    _cutLabel = [UILabel new];
    _cutLabel.font = [UIFont systemFontOfSize:14];
    _cutLabel.textColor = [UIColor whiteColor];
    _cutLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_cutLabel];
    
    _cutMLabel = [UILabel new];
    _cutMLabel.font = [UIFont systemFontOfSize:14];
    _cutMLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_cutMLabel];
    
}

-(void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(65);
        make.height.mas_equalTo(15);
    }];

    
    
    __weak typeof(self) weakSelf = self;
    [_setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(14);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(65);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(14);
    }];
    [_cutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyLabel.mas_right).offset(10.f);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(14);
    }];
    [_cutMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cutLabel.mas_right).offset(5.f);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(13);
    }];
    
}
@end
