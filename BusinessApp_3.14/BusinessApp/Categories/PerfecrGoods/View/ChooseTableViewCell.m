//
//  ChooseTableViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/5/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ChooseTableViewCell.h"

@implementation ChooseTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}


+(CGFloat)getHightWinthModel:(ChooseModel *)model{

    
    if ([model.strategy integerValue] == 3) {
        
        NSMutableString *dataString = [NSMutableString string];
        
        for (NSDictionary *dict in model.gift_goods) {
            
            NSString *str = [NSString stringWithFormat:@"%@  ×1",dict[@"goods_name"]];
            
            [dataString appendFormat:@"\n%@",str];
            
        }
        
        
        CGFloat w =  [AppUtil getScreenWidth]/2;
        
        CGSize titleSize = [dataString boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        return titleSize.height+44+5;
        
        
    }else{
       
        return 62;
    }
    
}

-(void)configModel:(ChooseModel *)model{
    
    _nameLabel.text = model.subject;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    if ([model.strategy integerValue] == 1) {
        _strategyLabel.text = [NSString stringWithFormat:@"立减%@元",model.special_subamount];
        _titleLabel.text = nil;
    }else if ([model.strategy integerValue] == 2){
    
        _strategyLabel.text = @"减";
        _titleLabel.text = model.title;
    }else if ([model.strategy integerValue] == 3){

        _strategyLabel.text = @"赠";
        _titleLabel.text = model.title;
    }
    
        NSMutableString *dataString = [NSMutableString string];
    
    if ([model.strategy integerValue] == 3) {

        
        for (NSDictionary *dict in model.gift_goods) {

            
            NSString *str = [NSString stringWithFormat:@"%@  ×1",dict[@"goods_name"]];
            
            [dataString appendFormat:@"%@\n",str];
    
        }
        
        _goodsNameLabel.text = dataString;
        
    }else{
        _goodsNameLabel.text = nil;
    }
    

}

-(void)initSubviews{
    
    _amount = 0;

    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_priceLabel];
    
    _strategyLabel = [UILabel new];
    _strategyLabel.font = [UIFont systemFontOfSize:14];
    _strategyLabel.textColor = [UIColor whiteColor];
    _strategyLabel.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _strategyLabel.layer.cornerRadius = 2.f;
    _strategyLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_strategyLabel];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_titleLabel];
    
    
    _goodsNameLabel = [UILabel new];
    _goodsNameLabel.font = [UIFont systemFontOfSize:13];
    _goodsNameLabel.numberOfLines = 0;
    _goodsNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_goodsNameLabel];
    
    
    _minus = [UIButton new];
    [_minus setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [_minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_minus];
    
    _plus = [UIButton new];
    [_plus setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [_plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_plus];
    
    _orderCount = [UILabel new];
    _orderCount.font = [UIFont systemFontOfSize:13];
    _orderCount.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_orderCount];

}



-(void)minus:(id)sender{
    
    self.amount -= 1;
    
    if (self.plusBlock) {
        self.plusBlock(self.amount,NO);
    }
    
    [self showOrderNumbers:self.amount];
}


-(void)plus:(id)sender{
    
    self.amount += 1;
    
    if (self.plusBlock) {
        self.plusBlock(self.amount,YES);
    }
    
    [self showOrderNumbers:self.amount];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showOrderNumbers:self.amount];
    
}


-(void)showOrderNumbers:(NSUInteger)count
{
    self.orderCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.amount];
    if (self.amount > 0)
    {
        [self.minus setHidden:NO];
        [self.orderCount setHidden:NO];
    }
    else
    {
        [self.minus setHidden:YES];
        [self.orderCount setHidden:YES];
    }
}




-(void)setLayout{
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    [_strategyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_priceLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(14);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(_strategyLabel.mas_right).offset(3.f);
        make.height.mas_equalTo(14);
    }];
    

    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_bottom).offset(5.f);
        make.left.mas_equalTo(15);
    }];
    

    [_plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_plus.mas_centerY);
        make.right.equalTo(_plus.mas_left).offset(-10.f);
        make.height.mas_equalTo(12);
    }];
    
    [_minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(_orderCount.mas_left).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    
    
}



@end
