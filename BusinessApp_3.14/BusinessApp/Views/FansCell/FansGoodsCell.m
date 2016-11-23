//
//  FansGoodsCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansGoodsCell.h"

@interface FansGoodsCell ()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
//名字
@property (weak, nonatomic) IBOutlet UILabel *goodName;
//钱数
@property (weak, nonatomic) IBOutlet UILabel *money;
//数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
//占比
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;



@end


@implementation FansGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configDataDic:(NSDictionary *)dic{
    self.money.text = @"¥12345";
    self.goodsNum.text = @"(50瓶)";
    self.percentLabel.text = @"90%";

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
