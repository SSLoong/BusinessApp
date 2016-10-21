//
//  OrderViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/24.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderViewCell.h"
#import <DateTools.h>

@implementation OrderViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initSubviews];
        
        [self setLayout];
    }
    
    return self;
}


-(void)configWithModel:(OrderModel *)model type:(NSInteger)type{

    
    if (type==0) {

        
        if ([model.receive_type integerValue]==1) {
            
            _stateImage.image = [UIImage imageNamed:@"order_left_top_01"];
            
            if ([model.pay_result integerValue]==1) {
                
                _payLabel.text = @"已付款";
                _payLabel.textColor = [UIColor colorWithHex:0x48B348];
                
                
                if ([model.status integerValue] == 0) {
                    
                    _deliveryLabel.textColor = [UIColor colorWithHex:0xFD5B44];
                    _deliveryLabel.text = @"未自提";
                    
                }
                
            }else {
                
                _payLabel.text = @"未付款";
                _payLabel.textColor = [UIColor colorWithHex:0xFD5B44];
                _deliveryLabel.text = @"";
                
            }
            
        }else{
            _stateImage.image = [UIImage imageNamed:@"order_left_top_02"];
            
            if ([model.pay_result integerValue]==1) {
                
                _payLabel.text = @"已付款";
                _payLabel.textColor = [UIColor colorWithHex:0x48B348];
                
                if ([model.status integerValue] == 0) {
                    
                    _deliveryLabel.textColor = [UIColor colorWithHex:0xFD5B44];
                    _deliveryLabel.text = @"待发货";
                }else if([model.status integerValue] == 4){
                    
                    _deliveryLabel.textColor = [UIColor colorWithHex:0xFD5B44];
                    _deliveryLabel.text = @"配送中";
                }else{
                    
                    _deliveryLabel.text = @"";
                }
                
            }else{
                _payLabel.text = @"未付款";
                _payLabel.textColor = [UIColor colorWithHex:0xFD5B44];
                _deliveryLabel.text = @"";
            }
            
        }

        
        
    }else{
    
    
        if ([model.receive_type integerValue]==1) {
            
            _stateImage.image = [UIImage imageNamed:@"order_left_top_01"];
            
        }else{
            _stateImage.image = [UIImage imageNamed:@"order_left_top_02"];

        }
        
            _payLabel.textColor = [UIColor colorWithHex:0x48B348];
        
        if ([model.status integerValue] == 1) {
            _payLabel.text = @"已完成";
        }else if([model.status integerValue] == 2){
            _payLabel.text = @"用户已取消";
        }else if([model.status integerValue] == 3){
            _payLabel.text = @"系统已取消";
        }
        

    }


    _phoneLabel.text = [NSString stringWithFormat:@"%@****%@",[model.phone substringToIndex:3],[model.phone substringFromIndex:7]];


    for (int i=0; i<model.goodsimgls.count; i++) {
        
        if (i==0) {
            [_goodsImage1 sd_setImageWithURL:[NSURL URLWithString:model.goodsimgls[i][@"cover_img"]] placeholderImage:[UIImage imageNamed:@"store_header"]];
            _goodsImage2.image = nil;
            _goodsImage3.image = nil;
            
        }else if(i==1){
            [_goodsImage2 sd_setImageWithURL:[NSURL URLWithString:model.goodsimgls[i][@"cover_img"]] placeholderImage:[UIImage imageNamed:@"store_header"]];
            _goodsImage3.image = nil;
            
        }else{
            [_goodsImage3 sd_setImageWithURL:[NSURL URLWithString:model.goodsimgls[i][@"cover_img"]] placeholderImage:[UIImage imageNamed:@"store_header"]];
        }
    }

    

    
    
    
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:model.create_time];
    _timeLabel.text = [fromdate timeAgoSinceNow];
    
    _moreImage.image = [UIImage imageNamed:@"order_more"];
    
    _gongjiLabel.text = @"共计";
    _goodsNumLabel.text = [NSString stringWithFormat:@"%@",model.total_goods];
    
    _goodsLabel.text = @"件商品";
    
    _shifuMoneyLabel.text = [NSString stringWithFormat:@"¥%@",model.real_amount];
    
    _shifuLabel.text = @"实付:";
    
    _butieMoneyLabel.text = [NSString stringWithFormat:@"¥%@",model.total_subsidy];
    
    _butieLabel.text = @"奖励:";

}



-(void)initSubviews{
    
    _stateImage = [UIImageView new];
    _stateImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_stateImage];
    
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = [UIColor blackColor];
    _phoneLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_phoneLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_timeLabel];
    
    
    _goodsImage1 = [UIImageView new];
    _goodsImage1.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_goodsImage1];
    
    _goodsImage2 = [UIImageView new];
    _goodsImage2.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_goodsImage2];
    
    _goodsImage3 = [UIImageView new];
    _goodsImage3.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_goodsImage3];
    
    
    _moreImage = [UIImageView new];
    _moreImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_moreImage];
    
    
    _payLabel = [UILabel new];
    _payLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_payLabel];
    
    
    _deliveryLabel = [UILabel new];
    _deliveryLabel.font= [UIFont systemFontOfSize:14.f];
    _deliveryLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_deliveryLabel];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView.alpha = 0.5;
    [self.contentView addSubview:_lineView];
    
    
    _gongjiLabel = [UILabel new];
    _gongjiLabel.textColor = [UIColor lightGrayColor];
    _gongjiLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_gongjiLabel];
    
    _goodsNumLabel = [UILabel new];
    _goodsNumLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _goodsNumLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_goodsNumLabel];
    
    _goodsLabel = [UILabel new];
    _goodsLabel.textColor = [UIColor lightGrayColor];
    _goodsLabel.font= [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_goodsLabel];
   
    
    _butieLabel = [UILabel new];
    _butieLabel.textColor = [UIColor lightGrayColor];
    _butieLabel.font= [UIFont systemFontOfSize:14.f];
    _butieLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_butieLabel];
    
    
    _butieMoneyLabel = [UILabel new];
    _butieMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _butieMoneyLabel.font= [UIFont systemFontOfSize:14.f];
    _butieMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_butieMoneyLabel];
    
    
    _shifuLabel = [UILabel new];
    _shifuLabel.textColor = [UIColor lightGrayColor];
    _shifuLabel.font= [UIFont systemFontOfSize:14.f];
    _shifuLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_shifuLabel];
    
    
    _shifuMoneyLabel = [UILabel new];
    _shifuMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _shifuMoneyLabel.font= [UIFont systemFontOfSize:14.f];
    _shifuMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_shifuMoneyLabel];
    
}


-(void)setLayout{
    
    [_stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.mas_equalTo(0);
        
        make.size.mas_equalTo(CGSizeMake(45, 45));
        
    }];
    
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_goodsImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_stateImage.mas_bottom).offset(0.f);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        
    }];

 
    [_goodsImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_stateImage.mas_bottom).offset(0.f);
        make.left.equalTo(_goodsImage1.mas_right).offset(15.f);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        
    }];
    
    [_goodsImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_stateImage.mas_bottom).offset(0.f);
        make.left.equalTo(_goodsImage2.mas_right).offset(15.f);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        
    }];
    
    [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_goodsImage3.mas_centerY);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(22, 4));
        
    }];
    
    
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(20);
        make.top.equalTo(_goodsImage1.mas_bottom).offset(15);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_deliveryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.top.equalTo(_payLabel.mas_top).offset(0.f);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.top.equalTo(_payLabel.mas_bottom).offset(15);
        
    }];
    
    
    [_gongjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.equalTo(_lineView.mas_bottom).offset(15.f);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_goodsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_gongjiLabel.mas_right).offset(1.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_goodsNumLabel.mas_right).offset(1.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    
    [_shifuMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_shifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_shifuMoneyLabel.mas_left).offset(-5.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_butieMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_shifuLabel.mas_left).offset(-8.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    [_butieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_butieMoneyLabel.mas_left).offset(-5.f);
        make.top.equalTo(_gongjiLabel.mas_top);
        make.height.mas_equalTo(14);
        
    }];
    
    
    
}




@end
