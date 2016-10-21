//
//  InventoryListCell.m
//  BusinessApp
//
//  Created by perfect on 16/3/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "InventoryListCell.h"

@implementation InventoryListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubview];
        [self setLayout];
    }
    return self;
}

-(void)cofigModel:(InventoryListModel *)model{
    if ([model.type integerValue] == 1) {
        _logoImage.image = [UIImage imageNamed:@"income_zaixian"];
    }else if ([model.type integerValue] == 2){
        _logoImage.image = [UIImage imageNamed:@"income_shangpin"];
    }else if ([model.type integerValue] == 3){
        _logoImage.image = [UIImage imageNamed:@"Income_huodong"];
    }
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.amount];
    _timeLabel.text = model.apply_time;

    if ([model.status integerValue] == 2 || [model.status integerValue] == 3){
        _setLabel.text = @"提现失败";
        _setLabel.textColor = [UIColor lightGrayColor];
    }else if ([model.status integerValue] == 4){
        _setLabel.text = @"提现成功";
        _setLabel.textColor = [UIColor colorWithHex:0x48B348];
    }else {
        _setLabel.text = @"提现中";
        _setLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    }

}
-(void)initSubview{
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont systemFontOfSize:18];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_moneyLabel];
    
    _setLabel = [UILabel new];
    _setLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_setLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];

}

-(void)setLayout{

    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoImage.mas_right).offset(10.f);
        make.centerY.mas_equalTo(_logoImage.mas_centerY);
        make.height.mas_equalTo(18);
    }];
    [_setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(14);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(14);
    }];
}
@end
