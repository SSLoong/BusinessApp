//
//  GeneralViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/5/4.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GeneralViewCell.h"

@implementation GeneralViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


-(void)configModel:(OrderDetailModel *)model{
    
    _nameLabel.text = model.goods_name;

    _numLabel.text = [NSString stringWithFormat:@"×%@",model.buy_num];
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    if ([model.sub_amount floatValue] != 0.f) {

        _subLabel.text = [NSString stringWithFormat:@"立减%@元",model.sub_amount];
        
    }
}

-(void)initSubviews{
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _subLabel = [UILabel new];
    _subLabel.font = [UIFont systemFontOfSize:14];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _subLabel.layer.cornerRadius = 2.f;
    _subLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_subLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLabel];
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
    
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    

    


}

@end
