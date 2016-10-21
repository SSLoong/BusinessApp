//
//  RewardTableViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/7/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "RewardTableViewCell.h"

@implementation RewardTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}

-(void)initSubviews{

    _rewardImg = [UIImageView new];
    _rewardImg.image = [UIImage imageNamed:@"ico-reward"];
    [self.contentView addSubview:_rewardImg];
    
    _taskImg  =[UIImageView new];
    _taskImg.image = [UIImage imageNamed:@"ico-task"];
    [self.contentView addSubview:_taskImg];
    
    _nonceImg = [UIImageView new];
    _nonceImg.image = [UIImage imageNamed:@"ico-nonce"];
    [self.contentView addSubview:_nonceImg];
    
    
    _completedLabel = [UILabel new];
    _completedLabel.textColor = [UIColor redColor];
    //_completedLabel.text = @"5元/瓶[最高200元]";
    _completedLabel.font = [UIFont systemFontOfSize:14];
    _completedLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_completedLabel];
    
    _rewardLabel = [UILabel new];
    _rewardLabel.numberOfLines = 0;
    _rewardLabel.textColor = [UIColor redColor];
    _rewardLabel.font = [UIFont systemFontOfSize:14];
    _rewardLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_rewardLabel];
    
    _stateLabel = [UILabel new];
    _stateLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _stateLabel.font = [UIFont systemFontOfSize:13];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_stateLabel];

    _grayLine = [UIView new];
    _grayLine.backgroundColor = [UIColor lightGrayColor];
    _grayLine.alpha = 0.5;
    [self.contentView addSubview:_grayLine];
    
    _grayLineOne = [UIView new];
    _grayLineOne.backgroundColor = [UIColor lightGrayColor];
    _grayLineOne.alpha = 0.5;
    [self.contentView addSubview:_grayLineOne];
    
}

-(void)setLayout{

    [_rewardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 20));
        
    }];
    
    [_taskImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.rewardImg.mas_bottom).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    [_nonceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 20));
        
    }];
    
    [_completedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_rewardImg.mas_right).with.offset(10);
        make.centerY.equalTo(_rewardImg);
        
    }];
    [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(_taskImg.mas_right).with.offset(10);
        make.centerY.equalTo(_taskImg);
        
    }];

    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_nonceImg.mas_right).with.offset(10);
        make.centerY.equalTo(_nonceImg);

    }];
    
    [_grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(59.5);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_offset(ScreenWidth-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [_grayLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(119.5);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_offset(ScreenWidth-15);
        make.height.mas_equalTo(0.5);
    }];
    
}

@end
