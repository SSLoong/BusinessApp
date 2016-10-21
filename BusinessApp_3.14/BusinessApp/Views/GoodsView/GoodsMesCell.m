//
//  GoodsMesCell.m
//  BusinessApp
//
//  Created by perfect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsMesCell.h"

@implementation GoodsMesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
        [self setLayout];
    }
    return self;
}

-(void)configModel:(GiftsModel *)model{

    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_header"]];
  
    _titleLabel.text = model.goods_name;
    
    _moneyLabel.text = @"¥0";
    
    _numLabel.text = [NSString stringWithFormat:@"×1"];
    
    _deleLabel.text = [NSString stringWithFormat:@"¥%@",model.goods_price];
    
    NSUInteger length = _deleLabel.text.length;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_deleLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(1, length-1)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1, length-1)];
    [_deleLabel setAttributedText:attri];
    
}


-(void)initSubviews{
    
    _topLine = [UIView new];
    _topLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_topLine];
    
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_titleLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont systemFontOfSize:12];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
//    [self.contentView addSubview:_moneyLabel];
    
    _deleLabel = [UILabel new];
    _deleLabel.font = [UIFont systemFontOfSize:10];
    _deleLabel.textColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:_deleLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_numLabel];
}



-(void)setLayout{
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_logoImage.mas_right).with.offset(10);
        make.centerY.mas_equalTo(_logoImage.mas_centerY);
        make.height.mas_equalTo(15);
    }];
//    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(65);
//        make.bottom.mas_equalTo(-10);
//        make.height.mas_equalTo(12);
//    }];
//    [_deleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(90);
//        make.bottom.mas_equalTo(-10);
//        make.height.mas_equalTo(10);
//    }];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
         make.centerY.mas_equalTo(_logoImage.mas_centerY);
        make.height.mas_equalTo(12);
    }];
}

@end
