//
//  GoodsAwardCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/17.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsAwardCell.h"

@implementation GoodsAwardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}

- (void)initSubviews{
    _goodsImg = [[UIImageView alloc]init];
    _goodsImg.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_goodsImg];

    _goodsName = [[UILabel alloc]init];
    _goodsName.text = @"53°茅台带杯飞天酒500ml";
    _goodsName.font = [UIFont systemFontOfSize:15];
    _goodsName.numberOfLines = 0;
    _goodsName.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_goodsName];
 
    _haveSaleLabel = [[UILabel alloc]init];
    _haveSaleLabel.text = @"已售5瓶｜";
    _haveSaleLabel.numberOfLines = 0;
    _haveSaleLabel.font = [UIFont systemFontOfSize:13];
    _haveSaleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_haveSaleLabel];


    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.text = @"5元／瓶｜";
    _moneyLabel.numberOfLines = 0;
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    _moneyLabel.textColor = [UIColor lightGrayColor];
    _moneyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_moneyLabel];
    
 
    
    
}

- (void)setLayout{
    [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];

    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goodsImg);
        make.left.equalTo(_goodsImg.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(10);
    }];
    
    
    [_haveSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsImg.mas_right).offset(10);
        make.top.equalTo(_goodsName.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 15));
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsImg.mas_right).offset(10);
        make.top.equalTo(_haveSaleLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(180, 15));
    }];
}


- (void)configSalesAwardModel:(SalesAwardModel *)model{
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:model.cover_img]];
    _goodsName.text = model.name;
    NSString *sjk_reward = [NSString stringWithFormat:@"%0.2f",[model.sjk_reward floatValue]];
    NSString *sumreward = [NSString stringWithFormat:@"%0.2f",[model.sumreward floatValue]];

    
    
    NSString *haveSaleStr = [NSString stringWithFormat:@"已售%@瓶｜剩余%@瓶",model.sale_num,model.stock];
    NSString *moneyStr = [NSString stringWithFormat:@"%@元/瓶｜累积奖励%@元",sjk_reward,sumreward];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:haveSaleStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,model.sale_num.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(haveSaleStr.length - model.stock.length - 1,model.stock.length)];

    
    NSMutableAttributedString *strOther = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [strOther addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,sjk_reward.length + 1)];
    [strOther addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(moneyStr.length - sumreward.length - 1,sumreward.length + 1)];
    

    
    _haveSaleLabel.attributedText = str;
    _moneyLabel.attributedText = strOther;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
