//
//  NoticeViewCell.m
//  BusinessApp
//
//  Created by perfect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "NoticeViewCell.h"

@implementation NoticeViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubview];
        [self setLayout];
    }
    return self;
}

-(void)initSubview{
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _smallImage = [UIImageView new];
    [self.contentView addSubview:_smallImage];
    
    
    _messLabel = [UILabel new];
    _messLabel.font = [UIFont systemFontOfSize:14];
    _messLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_messLabel];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    
    _orderLabel = [UILabel new];
    _orderLabel.font = [UIFont systemFontOfSize:13];
    _orderLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_orderLabel];
    

}
-(void)configModel:(NoticeModel *)model{
    
    _logoImage.image = [UIImage imageNamed:@"store_msg"];
    
    if ([model.flag integerValue] == 0) {
    _smallImage.image = [UIImage imageNamed:@"store_msg_round"];
        _smallImage.hidden = NO;
    }else{
        _smallImage.image = nil;
        _smallImage.hidden = YES;
    }

    _messLabel.text = model.title;
    _timeLabel.text = model.create_time;
    _orderLabel.text = model.content;

}

-(void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        
    }];
    [_smallImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7.5);
        make.left.mas_equalTo(28);
        make.size.mas_equalTo(CGSizeMake(5.5, 5.5));
    }];
    [_messLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(42);
        make.height.mas_equalTo(14);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(13);
    }];
    [_orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.left.mas_equalTo(42);
        make.height.mas_equalTo(13);
    }];
}
@end
