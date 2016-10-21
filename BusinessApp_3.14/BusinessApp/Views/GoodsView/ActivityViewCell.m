//
//  ActivityViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/30.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ActivityViewCell.h"

@implementation ActivityViewCell


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
        
    }
    return self;
}


-(void)configModel:(ActivityModel *)model{

    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.poster_pic] placeholderImage:[UIImage imageNamed:@"store_big_header"]];

    _timeLabel.text = [NSString stringWithFormat:@" %@ ",model.nowtime];
    
    _titleLabel.text = model.subject;
    
    if([model.isapply integerValue] == 1){
    
        _statuLabel.text = @"已参加";
        _statuLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    }else{
        
        _statuLabel.text = @"未参加";
        _statuLabel.textColor = [UIColor lightGrayColor];
    }

}

-(void)initSubviews{

    self.logoImage = [[UIImageView alloc]init];
    _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.logoImage];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor grayColor];
    _timeLabel.alpha = 0.8;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLabel];
    
    
    _statuLabel = [UILabel new];
    _statuLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_statuLabel];

}

-(void)setLayout{

    __weak typeof(self) weakSelf = self;

    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.mas_equalTo(0);

        make.size.mas_equalTo(CGSizeMake(weakSelf.bounds.size.width, weakSelf.bounds.size.width));
        

    }];
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        
        make.bottom.equalTo(_logoImage.mas_bottom);
        
        make.height.mas_equalTo(14);
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        
        make.top.equalTo(_logoImage.mas_bottom).offset(5.f);
        
    }];

    [_statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        
        make.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(14);
        
    }];
    

}




@end
