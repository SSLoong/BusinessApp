//
//  GoodsTableViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/4/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}

-(void)configModel:(GoodsDataModel *)model nowstatus:(NSInteger)nowstatus spetype:(NSInteger)spetype changeType:(NSString *)type{
    
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:model.cover_img] placeholderImage:[UIImage imageNamed:@"store_header"]];
    
    _titleLabel.text = model.goods_name;
    
        _priceLabel.text = @"售价:";

    _priceMoneyLabel.text = [NSString stringWithFormat:@"¥%@",model.real_price];
    
    if (spetype == 1) {
        if ([model.special_subamount integerValue] != 0) {
            _deleLabel.text = @"立减:";
            _deleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",model.special_subamount];
        }
    }
    
    if (nowstatus == 0) {
        if ([model.sale_flag integerValue] == 0) {
            
            _applyBtn.hidden = YES;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _statusLabel.hidden = NO;
            _statusLabel.text = @"审核中";
            _saleLabel.text = nil;
            
        }else if ([model.sale_flag integerValue] == 1){
            
            _applyBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _sumBtn.hidden = NO;
            NSInteger sum = [model.sale_num integerValue] + [model.total_stock integerValue];;
            NSString *title = [NSString stringWithFormat:@"%ld瓶",(long)sum];
            [_sumBtn setTitle:title forState:UIControlStateNormal];
            _statusLabel.hidden = YES;
            _saleLabel.text = nil;
        }else if ([model.sale_flag integerValue] == 2){
            
            _applyBtn.hidden = NO;
            _sumBtn.hidden = YES;
            _statusLabel.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _statusLabel.text = nil;
            [_applyBtn setTitle:@"重新申请" forState:UIControlStateNormal];
            _saleLabel.text = nil;
            
        }else if ([model.sale_flag integerValue] == 3){
            
            _applyBtn.hidden = NO;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            [_applyBtn setTitle:@" 参  加 " forState:UIControlStateNormal];
            _statusLabel.hidden = YES;
            _statusLabel.text = nil;
            _saleLabel.text = nil;

        }else if ([model.sale_flag integerValue] == 4){
            _applyBtn.hidden = YES;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = NO;
            _purchaseLabel.hidden = NO;
        }
    }else if (nowstatus == 1){
        
        if ([model.sale_flag integerValue] == 0) {
            
            _applyBtn.hidden = YES;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _statusLabel.hidden = NO;
            _statusLabel.text = @"审核中";
            _saleLabel.text = nil;
            
        }else if ([model.sale_flag integerValue] == 1) {
            _applyBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _sumBtn.hidden = NO;
            _statusLabel.hidden = YES;
            _statusLabel.text = nil;
            
            NSString *saleString = [NSString stringWithFormat:@"已售:%@  库存:%@",model.sale_num,model.total_stock];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:saleString];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFD5B44] range:NSMakeRange(3, model.sale_num.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFD5B44] range:NSMakeRange(saleString.length-model.total_stock.length, model.total_stock.length)];
            _saleLabel.attributedText = attributedString;
            
            NSInteger sum = [model.sale_num integerValue] + [model.total_stock integerValue];;
            NSString *title = [NSString stringWithFormat:@"%ld瓶",(long)sum];
            [_sumBtn setTitle:title forState:UIControlStateNormal];
        }else if ([model.sale_flag integerValue] == 2){
            
            _applyBtn.hidden = YES;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _statusLabel.hidden = NO;
            _statusLabel.text = @"申请失败";
            _saleLabel.text = nil;
            
        }else{
            
            _applyBtn.hidden = YES;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _statusLabel.hidden = NO;
            _statusLabel.text = @"未参加";
            _statusLabel.textColor = [UIColor redColor];
            _saleLabel.text = nil;
        }
    }else if (nowstatus == 2){

        if ([model.sale_flag integerValue] == 1) {
            
            _applyBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _sumBtn.hidden = NO;
            _statusLabel.hidden = YES;
            _statusLabel.text = nil;
            
            NSString *saleString = [NSString stringWithFormat:@"已售:%@  库存:%@",model.sale_num,model.total_stock];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:saleString];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFD5B44] range:NSMakeRange(3, model.sale_num.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFD5B44] range:NSMakeRange(saleString.length-model.total_stock.length, model.total_stock.length)];
            _saleLabel.attributedText = attributedString;
            
            NSInteger sum = [model.sale_num integerValue] + [model.total_stock integerValue];;
            NSString *title = [NSString stringWithFormat:@"%ld瓶",(long)sum];
            [_sumBtn setTitle:title forState:UIControlStateNormal];
            
        }else if ([model.sale_flag integerValue]  == 2){
            _applyBtn.hidden = YES;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _statusLabel.hidden = NO;
            _statusLabel.text = @"申请失败";
            _saleLabel.text = nil;
        }else{
            _applyBtn.hidden = YES;
            _sumBtn.hidden = YES;
            _purchaseBtn.hidden = YES;
            _purchaseLabel.hidden = YES;
            _statusLabel.hidden = NO;
            _statusLabel.text = @"未参加";
            _statusLabel.textColor = [UIColor redColor];
            _saleLabel.text = nil;

                }
    }
    
    
//    if (nowstatus == 0) {
//        
//        if ([model.sale_flag integerValue] == 3) {
//            
//            _applyBtn.hidden = NO;
//            [_applyBtn setTitle:@" 参加 " forState:UIControlStateNormal];
//            _statusLabel.hidden = YES;
//            _statusLabel.text = nil;
//            _saleLabel.text = nil;
//            
//        }else if([model.sale_flag integerValue] == 0){
//        
//            _applyBtn.hidden = YES;
//            _statusLabel.hidden = NO;
//            _statusLabel.text = @"审核中";
//            _saleLabel.text = nil;
//        }else if([model.sale_flag integerValue] == 2){
//        
//            _applyBtn.hidden = NO;
//            _statusLabel.hidden = YES;
//            _statusLabel.text = nil;
//            [_applyBtn setTitle:@" 重新申请 " forState:UIControlStateNormal];
//            _saleLabel.text = nil;
//
//        }else if ([model.sale_flag integerValue] == 4){
//            
//            
//            
//        }else{
//            _applyBtn.hidden = YES;
//            _statusLabel.hidden = YES;
//            _statusLabel.text = nil;
//
//            NSString *saleString = [NSString stringWithFormat:@"已售:%@  库存:%@",model.sale_num,model.total_stock];
//            
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:saleString];
//            
//            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, model.sale_num.length)];
//            
//            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(saleString.length-model.total_stock.length, model.total_stock.length)];
//            
//            _saleLabel.attributedText = attributedString;
//        }
//        
//        
//    }else{
//    
//        if ([model.sale_flag integerValue] != 1) {
//            
//            _applyBtn.hidden = YES;
//            _statusLabel.hidden = NO;
//            _statusLabel.text = @"未参加";
//            _saleLabel.text = nil;
//            
//        }else{
//            
//            _applyBtn.hidden = YES;
//            _statusLabel.hidden = YES;
//            _statusLabel.text = nil;
//
//            NSString *saleString = [NSString stringWithFormat:@"已售:%@  库存:%@",model.sale_num,model.total_stock];
//        
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:saleString];
//            
//            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFD5B44] range:NSMakeRange(3, model.sale_num.length)];
//            
//            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFD5B44] range:NSMakeRange(saleString.length-model.total_stock.length, model.total_stock.length)];
//            
//            _saleLabel.attributedText = attributedString;
//        }
//    
//    
//    }

}


-(void)initSubviews{
    
    _logoImage = [UIImageView new];
    [self.contentView addSubview:_logoImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:13];
    _priceLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_priceLabel];
    
    
    _priceMoneyLabel = [UILabel new];
    _priceMoneyLabel.font = [UIFont systemFontOfSize:13];
    _priceMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_priceMoneyLabel];
    
    
    _deleLabel = [UILabel new];
    _deleLabel.font = [UIFont systemFontOfSize:13];
    _deleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_deleLabel];
    
    _deleMoneyLabel = [UILabel new];
    _deleMoneyLabel.font = [UIFont systemFontOfSize:13];
    _deleMoneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    [self.contentView addSubview:_deleMoneyLabel];
    

    _applyBtn = [UIButton new];
    _applyBtn.backgroundColor = [UIColor colorWithHex:0xFF8800];
    [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _applyBtn.layer.masksToBounds = YES;
    _applyBtn.layer.cornerRadius = 10.0;
    _applyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_applyBtn setTitle:@"参  加" forState:UIControlStateNormal];
    [self.contentView addSubview:_applyBtn];
    
    
    _statusLabel = [UILabel new];
    _statusLabel.font = [UIFont systemFontOfSize:14];
    _statusLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_statusLabel];
    

    _saleLabel = [UILabel new];
    _saleLabel.font = [UIFont systemFontOfSize:13];
    _saleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_saleLabel];

    _purchaseLabel = [UILabel new];
    _purchaseLabel.hidden = YES;
    _purchaseLabel.font = [UIFont systemFontOfSize:14];
    _purchaseLabel.textColor = [UIColor lightGrayColor];
    _purchaseLabel.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"请从货源市场采购本商品"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, 4)];
    _purchaseLabel.attributedText = str;
    [self.contentView addSubview:_purchaseLabel];
    
    _purchaseBtn= [UIButton new];
    _purchaseBtn.hidden = YES;
    _purchaseBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [_purchaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _purchaseBtn.layer.masksToBounds = YES;
    _purchaseBtn.layer.cornerRadius = 10.0;
    _purchaseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_purchaseBtn setTitle:@"采  购" forState:UIControlStateNormal];
    [self.contentView addSubview:_purchaseBtn];
    
    _sumBtn = [UIButton new];
    [_sumBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _sumBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    _sumBtn.layer.masksToBounds = YES;
    _sumBtn.layer.cornerRadius = 10.0;
    _sumBtn.layer.borderWidth = 1.0;
    [_sumBtn setTitle:@"15瓶" forState:UIControlStateNormal];
    _sumBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_sumBtn];
    
    _grayLine = [UIView new];
    _grayLine.backgroundColor = [UIColor lightGrayColor];
    _grayLine.alpha = 0.5;
    [self.contentView addSubview:_grayLine];
}



-(void)setLayout{
    
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.left.mas_equalTo(15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
        make.right.mas_equalTo(-55);
    }];

    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.5);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
        make.height.mas_equalTo(13);
    }];
    
    
    [_priceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.left.equalTo(_priceLabel.mas_right).offset(2.f);
        make.height.mas_equalTo(13);
    }];
    
    
    [_deleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.left.equalTo(_priceMoneyLabel.mas_right).offset(5.f);
        make.height.mas_equalTo(13);
    }];
    
    
    
    [_deleMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.left.equalTo(_deleLabel.mas_right).offset(2.f);
        make.height.mas_equalTo(13);
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(-15);
    }];
    
    
    [_saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
    }];
    

    [_purchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_logoImage.mas_bottom);
        make.left.equalTo(_logoImage.mas_right).offset(5.f);
    }];
    
    
    [_purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [_sumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_logoImage.mas_centerY);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [_grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(0.5f);
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.width.mas_offset(ScreenWidth-15);
        make.height.mas_offset(0.5);
    }];
}

@end
