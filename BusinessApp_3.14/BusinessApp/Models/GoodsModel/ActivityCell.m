//
//  ActivityCell.m
//  BusinessApp
//
//  Created by AlexChang on 16/9/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _logoImage = [[UIImageView alloc]init];
        _logoImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_logoImage];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"白酒活动装场";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
        
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.text = @"赠";
        [_headerLabel sizeToFit];
        [_headerLabel.layer setMasksToBounds:YES];
        _headerLabel.layer.cornerRadius = 8;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.backgroundColor = [UIColor redColor];
        _headerLabel.font = [UIFont systemFontOfSize:12];
        _headerLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_headerLabel];
        
        _youhuiLabel = [[UILabel alloc]init];
        _youhuiLabel.text = @"满200减20";
        _youhuiLabel.numberOfLines = 0;
        _youhuiLabel.font = [UIFont systemFontOfSize:12];
        _youhuiLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_youhuiLabel];
        

        _statuLabel = [[UILabel alloc]init];
        _statuLabel.text = @"店铺活动";
        _statuLabel.numberOfLines = 0;
        _statuLabel.font = [UIFont systemFontOfSize:13];
        _statuLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_statuLabel];
        
        _jiangliLabel = [[UILabel alloc]init];
        _jiangliLabel.font = [UIFont systemFontOfSize:13];
        _jiangliLabel.numberOfLines = 0;
        _jiangliLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_jiangliLabel];
        
        _isInLabel = [[UILabel alloc]init];
        _isInLabel.text = @"未参加";
        _isInLabel.textColor = [UIColor redColor];
        _isInLabel.textAlignment = NSTextAlignmentRight;
        _isInLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_isInLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"9月05日开售";
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentRight;
       [self.contentView addSubview:_timeLabel];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods_time"]];
        [self.contentView addSubview:imgView];
        
        [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_logoImage.mas_right).with.offset(10);
            make.top.mas_equalTo(_logoImage.mas_top);
            make.height.mas_equalTo(16);
        }];
        
        [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.top.mas_equalTo(30);
            make.size.mas_equalTo(CGSizeMake(32, 16));
        }];

        [_youhuiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerLabel.mas_right).with.offset(5);
            make.centerY.equalTo(_headerLabel);
            make.height.mas_equalTo(16);
        }];

        [_statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.bottom.mas_equalTo(_logoImage.mas_bottom);
            make.height.mas_equalTo(16);
        }];
        
        [_jiangliLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.bottom.mas_equalTo(_statuLabel.mas_top);
            make.height.mas_equalTo(16);
        }];
        
        [_isInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
            make.top.mas_equalTo(_titleLabel.mas_top);
            make.height.mas_equalTo(16);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
            make.bottom.mas_equalTo(_logoImage.mas_bottom);
            make.height.mas_equalTo(16);
        }];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_timeLabel.mas_left).with.offset(-5);
            make.bottom.mas_equalTo(_logoImage.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return self;
}

-(void)setModel:(ActivityModel *)model
{
    _model = model;
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.poster_pic]];
    _titleLabel.text = model.subject;
    [_titleLabel sizeToFit];
    if ([model.strategy containsString:@"满"] && [model.strategy containsString:@"减"]) {
        _headerLabel.text = @"减";
        _youhuiLabel.text = model.strategy;
    }else if ([model.strategy containsString:@"赠"]){
        _headerLabel.text = @"赠";
        _youhuiLabel.text = model.strategy;
    }else{
        _headerLabel.text = @"立减";
        _youhuiLabel.text = model.strategy;
    }

    if ([model.goods_type integerValue] ==1) {
        _statuLabel.text = @"店铺活动";
        _statuLabel.textColor = [UIColor lightGrayColor];
    }else{
        _statuLabel.text = @"货源市场活动";
        _statuLabel.textColor = [UIColor orangeColor];
    }
    
    //if ([model.award_num integerValue] != 0) {
        NSString *jiangliString  = [NSString stringWithFormat:@"奖励：%@元/瓶[最高%@元]",model.award_num,model.upper_award_num];
        NSRange range = [jiangliString rangeOfString:@"/瓶[最高"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:jiangliString];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(jiangliString.length-1,1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,3)];
        
        _jiangliLabel.attributedText = str;
    // }
    
    if ([model.isapply integerValue] ==1) {
        _isInLabel.text = @"已参加";
        _isInLabel.textColor = [UIColor lightGrayColor];
    }else{
        _isInLabel.text = @"未参加";
        _isInLabel.textColor = [UIColor redColor];
    }
    
    _timeLabel.text = model.nowtime;
    
}
@end
