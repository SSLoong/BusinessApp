//
//  withdrawCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "withdrawCell.h"

@implementation withdrawCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}

-(void)initSubviews{

    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _moneyLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_moneyLabel];
    
    _stateLabel = [UILabel new];
    _stateLabel.textColor = [UIColor grayColor];
    _stateLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_stateLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_stateLabel];
    
}

-(void)setLayout{


    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(45, 45));
        
        make.left.and.top.mas_equalTo(10);
        
    }];
    
    
    
    __weak typeof(self) weakSelf = self;
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.height.mas_equalTo(16);
        
        make.left.mas_equalTo(15);
        
        make.centerY.equalTo(weakSelf.mas_centerY).offset(0.f);
        
        
    }];
    
    
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        
        make.right.mas_equalTo(-10);
        
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-10);
        
        make.height.mas_equalTo(14);
        
        make.right.mas_equalTo(-10);
        
    }];
    

}


@end
