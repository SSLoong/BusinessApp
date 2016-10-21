//
//  DeliverysViewCell.m
//  BusinessApp
//
//  Created by perfect on 16/4/6.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "DeliverysViewCell.h"

@implementation DeliverysViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}

-(void)initSubviews{

    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_addressLabel];
    
    _tLabel = [UILabel new];
    _tLabel.font = [UIFont systemFontOfSize:14];
    _tLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_tLabel];
}

-(void)setLayout{
    
    __weak typeof(self) weakSelf = self;
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    [_tLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        
    }];

}
@end
