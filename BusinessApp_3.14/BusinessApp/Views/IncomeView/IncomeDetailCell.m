//
//  IncomeDetailCell.m
//  BusinessApp
//
//  Created by prefect on 16/3/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "IncomeDetailCell.h"
#import "IncomeDetailModel.h"


@implementation IncomeDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self initSubviews];
        
        [self setLayout];
    }

    return self;
}


//-(void)configModel:(IncomeDetailModel *)model row:(NSInteger)row{
//
//    if (row==0) {
//        _logoImage.image = [UIImage imageNamed:@"income_zaixian"];
//        
//        NSString *moneyString = [NSString stringWithFormat:@"¥ %@",model.real_amount];
//        
//        _moneyLabel.text = moneyString;
//        
//    }else{
//        _logoImage.image = [UIImage imageNamed:@"income_shangpin"];
//        
//        NSString *moneyString = [NSString stringWithFormat:@"¥ %@",model.sumdealer_subsidy];
//        
//        _moneyLabel.text = moneyString;
//    }
//
//    _timeLabel.text = model.create_time;
//
//    NSMutableString *dataString = [NSMutableString string];
//    
//    for (NSDictionary *dict in model.orderdetails) {
//        
//        NSString *str = [NSString stringWithFormat:@"%@×%@",dict[@"goodsname"],dict[@"buy_num"]];
//        
//        [dataString appendFormat:@"%@\n",str];
//        
//    }
//
//    _dataLabel.text = dataString;
//    
//}
//
//
//
//+(CGFloat)getHightWinthModel:(IncomeDetailModel *)model{
//
//    NSMutableString *dataString = [NSMutableString string];
//    
//    for (NSDictionary *dict in model.orderdetails) {
//        
//        NSString *str = [NSString stringWithFormat:@"%@×%@",dict[@"goodsname"],dict[@"buy_num"]];
//        
//        [dataString appendFormat:@"%@\n",str];
//
//    }
//
//    
//    CGFloat w =  [AppUtil getScreenWidth]-194;
//    
//    CGSize titleSize = [dataString boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
//    
//    if (titleSize.height<=65) {
//        return 65;
//    }else{
//    
//        return titleSize.height+5;
//    }
//}
//
//
//+(NSInteger)getRowsWithModel:(IncomeDetailModel *)model{
//
//    
//    if ([model.sumdealer_subsidy integerValue] > 0) {
//        
//        return 2;
//    }else{
//    
//        return 1;
//    }
//}


-(void)initSubviews{

    _logoImage = [UIImageView new];
    _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_logoImage];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font= [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_timeLabel];

    _moneyLabel = [UILabel new];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _moneyLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_moneyLabel];

    _dataLabel = [UILabel new];
    _dataLabel.numberOfLines = 0;
    _dataLabel.textColor = [UIColor lightGrayColor];
    _dataLabel.font= [UIFont systemFontOfSize:12.f];
    _dataLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dataLabel];

    
}

- (void)setLayout{
    
[_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
   
    make.size.mas_equalTo(CGSizeMake(45, 45));
    
    make.top.mas_equalTo(10);

    make.left.mas_equalTo(16);
    
}];

    
[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.left.equalTo(_logoImage.mas_right).offset(10.f);
    
    make.top.mas_equalTo(10);
    
    make.size.mas_equalTo(CGSizeMake(108, 12));
    
}];
    
[_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
         make.left.equalTo(_logoImage.mas_right).offset(10.f);
    
         make.top.equalTo(_timeLabel.mas_bottom).offset(10.f);
    
         make.height.mas_equalTo(18);
    
     }];
    
    


[_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.top.mas_equalTo(10);
    make.right.mas_equalTo(-10);
    
    make.left.equalTo(_timeLabel.mas_right).offset(2.f);
 
}];



}



@end
