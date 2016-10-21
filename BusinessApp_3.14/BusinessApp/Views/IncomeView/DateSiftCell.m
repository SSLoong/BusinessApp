//
//  DateSiftCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "DateSiftCell.h"

@interface DateSiftCell ()


@end


@implementation DateSiftCell

+(CGFloat)cellHeight{
    return 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        [self setLayout];
    }
    return self;
}


- (void)creatUI{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, ([DateSiftCell cellHeight] - 15)/2, 60, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_timeLabel];
    }
}

- (void)setLayout{
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_titleLabel.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
