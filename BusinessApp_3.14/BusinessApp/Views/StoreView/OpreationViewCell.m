//
//  OpreationViewCell.m
//  BusinessApp
//
//  Created by perfect on 16/3/30.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OpreationViewCell.h"

@implementation OpreationViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubview];
        [self setLayout];
    }
    return self;
}

-(void)configModel:(MangerModel *)model{
    
    _nameLabel.text = @"操作员";
    
    _phoneLabel.text = model.login_phone;
    
    if ([model.status integerValue] == 0) {
        
        _oneSwitch.on = NO;
        
    }else{
        
        _oneSwitch.on = YES;
        
    }
    
    
}
-(void)initSubview{
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    _phoneLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_phoneLabel];
    
    _oneSwitch = [UISwitch new];
    _oneSwitch.on = NO;
    _oneSwitch.onTintColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_oneSwitch];
    
}

-(void)setLayout{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.right.mas_equalTo(_oneSwitch.mas_left).offset(-10.f);
        make.height.mas_equalTo(14);
    }];
    [_oneSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(_phoneLabel.mas_centerY);
    }];

}

@end
