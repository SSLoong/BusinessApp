//
//  InventoryCell.m
//  TestTest
//
//  Created by perfect on 16/3/29.
//  Copyright © 2016年 prefect. All rights reserved.
//

#import "InventoryCell.h"
#import "Masonry.h"
@implementation InventoryCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}


-(void)configModel:(GoodsDetailModel *)model{

    _timeLabel.text = model.create_time;
    _numLabel.text = [NSString stringWithFormat:@"×%@",model.buy_num];
    _priceLabel.text = @"售价:";
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    _totalLabel.text = @"小计:";
    _aggregateLabel.text = [NSString stringWithFormat:@"¥%@",model.sumprice];
 
    if ([model.goods_type integerValue] == 2) {
        
        _headLabel.text = @"专场   ";
        
        _headLabel.layer.borderColor =  [[UIColor redColor]CGColor];
        
        _headLabel.layer.borderWidth = 1.0f;
        
        _headLabel.layer.masksToBounds = YES;
    }else{
        
        if([model.store_subamount integerValue] != 0){

            _headLabel.text = [NSString stringWithFormat:@"立减¥%@   ",model.store_subamount];
            
            _headLabel.layer.borderColor =  [[UIColor redColor]CGColor];
            
            _headLabel.layer.borderWidth = 1.0f;
            
            _headLabel.layer.masksToBounds = YES;
            
            
    }
}

}

-(void)initSubviews{
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.tintColor = [UIColor blackColor];
    [self.contentView addSubview:_numLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    _priceLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_priceLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    _moneyLabel.textColor =[UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_moneyLabel];
    
    _headLabel = [UILabel new];
    _headLabel.font = [UIFont systemFontOfSize:12];
    _headLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _headLabel.textAlignment = NSTextAlignmentCenter;
   
    [self.contentView addSubview:_headLabel];
    
    _totalLabel = [UILabel new];
    _totalLabel.font  = [UIFont systemFontOfSize:14];
    _totalLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_totalLabel];
    
    _aggregateLabel = [UILabel new];
    _aggregateLabel.font = [UIFont systemFontOfSize:14];
    _aggregateLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_aggregateLabel];
    
    
}
-(void)setLayout{
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(13);
    }];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(13);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_timeLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(14);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_top);
        make.left.equalTo(_priceLabel.mas_right).offset(10.f);
        make.height.mas_equalTo(13);
    }];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_top);
        make.left.equalTo(_moneyLabel.mas_right).offset(10.f);
        make.height.mas_equalTo(14);
    }];
    [_aggregateLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_priceLabel.mas_top);
        make.height.mas_equalTo(14);
    }];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_aggregateLabel.mas_left).offset(-10.f);
        make.top.mas_equalTo(_priceLabel.mas_top);
        make.height.mas_equalTo(14);
    }];
}
@end
