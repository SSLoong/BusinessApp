//
//  SaleTableViewCell.m
//  BusinessApp
//
//  Created by prefect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SaleTableViewCell.h"

@implementation SaleTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
        
        [self setLayout];
    }
    return self;
}

-(void)configModel:(SaleHeaderModel *)model{

    _nameLabel.text = model.dealer_name;
 
//    _addressLabel.text = model.company_address;
//    _phoneLabel.text = model.company_tel;
    
    if ([model.spetype integerValue] ==1) {

        _typeImage.image = [UIImage imageNamed:@"goods_jian"];
        _headerLabel.text = @"立减";
    }else if([model.spetype integerValue] ==2){
        _headerLabel.text = @"减";
        _typeImage.image = [UIImage imageNamed:@"goods_jian"];
    }else{
        _headerLabel.text = @"赠";
        _typeImage.image = [UIImage imageNamed:@"goods_add"];
    }

    _typeLabel.text = model.strategy;
    
    //NSString *str = [model.time substringFromIndex:3];
    NSMutableString *str = [[NSMutableString alloc ]initWithString:model.time];
    [str deleteCharactersInRange:NSMakeRange(0, 3)];
    [str deleteCharactersInRange:NSMakeRange(7, 3)];
    //  nsm *timeStr = [str dele]
    _timeLabel.text = str;

    if ([self.type integerValue] == 1) {
        _statuLabel.text = @"普通活动";
    }else{
        _statuLabel.text = @"货源市场活动";
    }
}

-(void)initSubviews{
    
    _headerLabel = [[UILabel alloc]init];
    [_headerLabel sizeToFit];
    [_headerLabel.layer setMasksToBounds:YES];
    _headerLabel.layer.cornerRadius = 6;
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.backgroundColor = [UIColor redColor];
    _headerLabel.font = [UIFont systemFontOfSize:10];
    _headerLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_headerLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _addressLabel = [UILabel new];
    _addressLabel.textColor = [UIColor lightGrayColor];
    _addressLabel.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:_addressLabel];
    
    
    _phoneImage = [[UIImageView alloc]init];
    _phoneImage.image = [UIImage imageNamed:@"goods_phone-1"];
    _phoneImage.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_phoneImage];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = [UIColor lightGrayColor];
    _phoneLabel.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:_phoneLabel];

    _typeImage = [[UIImageView alloc]init];
    _typeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_typeImage];
    
    
    _typeLabel = [UILabel new];
    _typeLabel.textColor = [UIColor lightGrayColor];
    _typeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_typeLabel];
    
    _statuLabel = [UILabel new];
    _statuLabel.textColor = [UIColor orangeColor];
    _statuLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_statuLabel];
    
    _timeImage = [[UIImageView alloc]init];
    _timeImage.image = [UIImage imageNamed:@"goods_time"];
    _timeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_timeImage];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_bottomLine];
}

-(void)setLayout{
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        
        make.top.mas_offset(10);
        
        make.height.mas_equalTo(14);
        
    }];
    
    
//    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(15);
//        
//        make.top.equalTo(_nameLabel.mas_bottom).offset(10.f);
//        
//        make.height.mas_equalTo(12);
//        
//    }];
    
    
//    [_phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(15);
//        
//        make.top.equalTo(_addressLabel.mas_bottom).offset(10.f);
//        
//        make.size.mas_equalTo(CGSizeMake(12, 12));
//        
//    }];
    
    
//    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(_phoneImage.mas_right).offset(2.f);
//        
//        make.top.equalTo(_addressLabel.mas_bottom).offset(10.f);
//        
//        make.height.mas_equalTo(12);
//        
//    }];
//
//    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(15);
//        
//        make.top.equalTo(_nameLabel.mas_bottom).offset(10.f);
//        
//        make.size.mas_equalTo(CGSizeMake(12, 12));
//        
//    }];
    
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(15);
        
        make.top.equalTo(_nameLabel.mas_bottom).offset(10.f);
        
        make.size.mas_equalTo(CGSizeMake(24, 12));
        
    }];
    
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headerLabel.mas_right).offset(5.f);
        
        make.top.equalTo(_nameLabel.mas_bottom).offset(10.f);
        
        make.height.mas_equalTo(12);
        
    }];
    

    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        
        make.top.equalTo(_typeLabel.mas_top);
        
        make.height.mas_equalTo(12);
        
    }];
    
    
    [_timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_timeLabel.mas_left).offset(-5.f);
        
        make.top.equalTo(_typeLabel.mas_top);
        
        make.size.mas_equalTo(CGSizeMake(12, 12));
        
    }];
    
    [_statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        
        make.top.equalTo(_nameLabel.mas_top);
        
        make.height.mas_equalTo(13);
        
    }];
    
    
}


@end
