//
//  OrderStateCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderStateCell.h"

@implementation OrderStateCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}

-(void)initSubviews{
    
    _goodsLabel = [UILabel new];
    _goodsLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _goodsLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_goodsLabel];
    

    _sureBtn  = [UIButton new];
    _sureBtn.hidden = YES;
    _sureBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_sureBtn];
    
    
}

-(void)setLayout{
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.mas_equalTo(14);
        make.height.mas_equalTo(16);
    }];
    
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(80, 34));
        make.right.mas_equalTo(-15);
    }];
    
}




@end
