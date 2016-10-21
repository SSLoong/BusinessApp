//
//  IncomeGoodsCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "IncomeGoodsCell.h"

@implementation IncomeGoodsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}


-(void)configWithModel:(IncomeGoodsModel *)model{

    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_header"]];
    
    _nameLabel.text = model.name;
    
    _numsLabel.text = [NSString stringWithFormat:@"×%@",model.nums];
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.sumamount];
    
    _otherLabel.text = @"小计:";

}


-(void)initSubviews{
    
    _logoImage = [UIImageView new];
    _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font= [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_nameLabel];
    
    _numsLabel = [UILabel new];
    _numsLabel.textColor = [UIColor blackColor];
    _numsLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numsLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _priceLabel.font= [UIFont systemFontOfSize:14.f];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    
    _otherLabel = [UILabel new];
    _otherLabel.textColor = [UIColor lightGrayColor];
    _otherLabel.textAlignment = NSTextAlignmentRight;
    _otherLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_otherLabel];
    
    
}

- (void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(45, 45));
        
        make.top.mas_equalTo(10);
        
        make.left.mas_equalTo(10);
        
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_logoImage.mas_right).offset(10.f);
        
        make.top.mas_equalTo(10);
 
        make.height.mas_equalTo(16);
        
    }];
    
    [_numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_logoImage.mas_right).offset(10.f);
        
        make.bottom.mas_equalTo(-10);
        
        make.height.mas_equalTo(14);
        
    }];
    
    
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-10);
        
        make.right.mas_equalTo(-10);
        
        make.height.mas_equalTo(14);
        
    }];


    [_otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-10);
        
        make.right.equalTo(_priceLabel.mas_left).offset(-5.f);
        
        make.height.mas_equalTo(14);
        
    }];

}

@end
