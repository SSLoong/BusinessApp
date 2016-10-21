//
//  HistoryViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/31.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "HistoryViewCell.h"

@implementation HistoryViewCell



-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
        
    }
    return self;
}


-(void)configModel:(HistoryModel *)model{
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.poster_pic] placeholderImage:[UIImage imageNamed:@"store_big_header"]];
    
    _titleLabel.text = model.subject;

    _statuLabel.text = [NSString stringWithFormat:@"结束时间:%@",model.end_time];

}



-(void)initSubviews{
    
    self.logoImage = [[UIImageView alloc]init];
    _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.logoImage];
    
    
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
