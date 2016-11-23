//
//  FansConsumeCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansConsumeCell.h"

@interface FansConsumeCell ()

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *vipLevel;


@end


@implementation FansConsumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configDataDic:(NSDictionary *)dic{
    self.money.text = @"¥12345";
    self.vipLevel.text = @"10";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
