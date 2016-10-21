//
//  BankListTableViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "BankListTableViewCell.h"

@implementation BankListTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}

-(void)initSubviews{

    _bankNameLabel = [UILabel new];
    _bankNameLabel.textColor = [UIColor blackColor];
    _bankNameLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_bankNameLabel];

    _typeLabel = [UILabel new];
    _typeLabel.textColor = [UIColor lightGrayColor];
    _typeLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_typeLabel];
    
    
    _cardLabel = [UILabel new];
    _cardLabel.textColor = [UIColor lightGrayColor];
    _cardLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_cardLabel];
    
    
    _defaultLabel = [UILabel new];
    _defaultLabel.textColor = [UIColor lightGrayColor];
    _defaultLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_defaultLabel];
}


-(void)configWithModel:(BankListModel *)model{


    _bankNameLabel.text = model.open_branch;
    
    _typeLabel.text = @"储蓄卡";

    NSString *cardString = [NSString stringWithFormat:@"尾号%@",model.bank_card];
    
    _cardLabel.text = cardString;

    _defaultLabel.text = @"默认";

    if ([model.is_default integerValue]>0) {
        _defaultLabel.hidden = NO;
    }else{
        _defaultLabel.hidden = YES;
    }
}

-(void)setLayout{

[_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.top.mas_equalTo(15);
    
    make.left.mas_equalTo(15);
    
    make.height.mas_equalTo(14);
    
}];
    
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.top.equalTo(_bankNameLabel);
        
        make.left.equalTo(_bankNameLabel.mas_right).offset(10.f);
        
        
    }];
    
    [_cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.top.equalTo(_bankNameLabel);
        
        make.left.equalTo(_typeLabel.mas_right).offset(10.f);
        
        
    }];
    
    [_defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        
        make.right.mas_equalTo(-15);
        
        make.height.mas_equalTo(14);
        
    }];


}

@end
