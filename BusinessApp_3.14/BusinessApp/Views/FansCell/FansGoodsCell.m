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

- (void)configGoodsListModel:(FansGoodsListModel *)model{
    NSString *money = [NSString stringWithFormat:@"¥%@",model.money];
    NSString *num = [NSString stringWithFormat:@"(%@瓶)",model.num];
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.cover_img]];
    self.goodName.text = model.goods_name;
    self.money.text = money;
    self.goodsNum.text = num;
    self.percentLabel.text = model.result;

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
