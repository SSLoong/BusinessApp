//
//  GoodsViewCell.m
//  UserApp
//
//  Created by prefect on 16/4/20.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsViewCell.h"

@implementation GoodsViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(GoodsModel *)model{
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"logo_place"]];
    
    _nameLabel.text = model.goods_name;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    if ([model.sub_amount floatValue] != 0.f) {
        
        _subLabel.text = [NSString stringWithFormat:@"立减%@元",model.sub_amount];
    }else{
        _subLabel.text = nil;
    }

    if (model.orderCount > 0) {
        
        _countLabel.text = [NSString stringWithFormat:@"%ld",(long)model.orderCount];
        
        if (_minus.hidden) {
            [_minus setHidden:NO];
        }
    }else{

        _countLabel.text = nil;
        if (!_minus.hidden) {
            [_minus setHidden:YES];
        }
    }
    
    
}

-(void)initSubviews{

    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLabel];

    _subLabel = [UILabel new];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _subLabel.font = [UIFont systemFontOfSize:12];
    _subLabel.layer.cornerRadius = 2.f;
    _subLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_subLabel];
    
    _minus = [UIButton new];
    [_minus setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_minus];
    
    _plus = [UIButton new];
    [_plus setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_plus];
    
    _countLabel = [UILabel new];
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_countLabel];

}

-(void)minus:(id)sender{
    
    if (self.addBlock) {
        self.addBlock(NO);
    }

}


-(void)plus:(id)sender{

    if (self.addBlock) {
        self.addBlock(YES);
    }
}


-(void)setLayout{

    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.left.equalTo(_logoImage.mas_right).offset(5);
        make.height.mas_equalTo(14);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(14);
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_priceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(14);
    }];
    
    [_plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_plus.mas_centerY);
        make.right.equalTo(_plus.mas_left).offset(-10.f);
        make.height.mas_equalTo(12);
    }];

    [_minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.right.equalTo(_countLabel.mas_left).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}
@end
