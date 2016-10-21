//
//  SpecialsViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/6/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpecialsViewCell.h"

@implementation SpecialsViewCell


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

}

-(void)initSubviews{
    
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];

    
    _subLabel = [UILabel new];
    _subLabel.textColor = [UIColor whiteColor];
    _subLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _subLabel.font = [UIFont systemFontOfSize:12];
    _subLabel.layer.cornerRadius = 2.f;
    _subLabel.layer.masksToBounds = YES;
    _subLabel.text = @"专场商品";
    [self.contentView addSubview:_subLabel];

    
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
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(14);
    }];

}

@end
