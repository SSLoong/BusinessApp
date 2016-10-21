//
//  PaySpecialViewCell.m
//  UserApp
//
//  Created by prefect on 16/5/19.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PaySpecialViewCell.h"

@implementation PaySpecialViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}



-(void)configModel:(SpecialsModel *)model{
  
    
 if ([model.mk_strategy integerValue] == 3){

    NSDictionary *giftDic = [model.marketing[@"gift_goods"] firstObject];

     _strategyView.image = [UIImage imageNamed:@"goods_add"];
     
     _strategyLabel.text = giftDic[@"goods_name"];
     
     _numLabel.text =  [NSString stringWithFormat:@"x%@",giftDic[@"num"]];
    
 
 }else{
    
     _strategyView.image = [UIImage imageNamed:@"goods_jian"];
     
     _strategyLabel.text = model.strategy;
     
     _numLabel.text = nil;
    
}

}

-(void)initSubviews{
    
    _strategyView = [UIImageView new];
    [self.contentView addSubview:_strategyView];
    
    _strategyLabel = [UILabel new];
    _strategyLabel.font = [UIFont systemFontOfSize:13];
    _strategyLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_strategyLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_numLabel];

}


-(void)setLayout{
    
    __weak typeof(self) weakSelf = self;
    
    [_strategyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    
    [_strategyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.equalTo(_strategyView.mas_right).offset(3.f);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(-10);
    }];
    
}

@end
