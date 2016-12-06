//
//  GoodsSellViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsSellViewCell.h"

@implementation GoodsSellViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}


-(void)configModel:(GoodsSellModel *)model{

    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_header"]];
    
    _nameLabel.text = model.goods_name;
    
    _priceLabel.text = @"售价:";
    
    _priceMoneyLabel.text = [NSString stringWithFormat:@"%@元",model.price];
    
     NSString *stockStr = [NSString stringWithFormat:@"库存%@瓶",model.stock];
    
    NSMutableAttributedString * Mstr = [Tool addColorWithString:stockStr atRange:NSMakeRange(2, stockStr.length - 3) withColor:[UIColor redColor]];
    
    _subsidyLabel.attributedText = Mstr;
    
    
    if([model.status  isEqualToString:@"0"]){
        _stateBtn.hidden = NO;
        [_stateBtn setImage:[UIImage imageNamed:@"Goods_sale_off"] forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"1"]){
        _stateBtn.hidden = NO;
        [_stateBtn setImage:[UIImage imageNamed:@"Goods_sale_on"] forState:UIControlStateNormal];
    }
}


-(void)initSubviews{
    
    _logoImage = [UIImageView new];
    _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor lightGrayColor];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLabel];
    
    _priceMoneyLabel = [UILabel new];
    _priceMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _priceMoneyLabel.font= [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceMoneyLabel];
    
    _subsidyLabel = [UILabel new];
    _subsidyLabel.textColor = [UIColor lightGrayColor];
    _subsidyLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_subsidyLabel];
    
    _subsidyMoneyLabel = [UILabel new];
    _subsidyMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _subsidyMoneyLabel.font= [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_subsidyMoneyLabel];
    
    
    _stateBtn = [UIButton new];
    [self.contentView addSubview:_stateBtn];
    
}

- (void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(45, 45));
        
        make.top.mas_equalTo(10);
        
        make.left.mas_equalTo(10);
        
    }];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_logoImage.mas_right).offset(10.f);
        
        make.right.equalTo(_stateBtn.mas_left).offset(0.f);
        
        make.top.mas_equalTo(10);
        
        make.height.mas_equalTo(14);
        
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_logoImage.mas_right).offset(10.f);
        
        make.bottom.mas_equalTo(-10);
        
        make.height.mas_equalTo(14);
        
    }];
    
    
    
    [_priceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-10);
        
        make.left.equalTo(_priceLabel.mas_right).offset(5.f);;
        
        make.height.mas_equalTo(14);
        
    }];
    
    

    
    [_subsidyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-10);
        
        make.left.equalTo(_priceMoneyLabel.mas_right).offset(10.f);
        
        //make.height.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(80, 14));
        
    }];
    
//
//    [_subsidyMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.bottom.mas_equalTo(-10);
//        
//        make.left.equalTo(_subsidyLabel.mas_right).offset(5.f);
//        
//        make.height.mas_equalTo(14);
//        
//    }];
    
    
    
    __weak typeof(self) weakSelf = self;
    
    [_stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(96, 60));
        
        make.right.mas_equalTo(0);
        
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        
    }];
    
}





@end
