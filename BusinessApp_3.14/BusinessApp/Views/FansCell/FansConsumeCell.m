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

- (void)configDataModel:(FansInfoModel *)model{
    self.money.text = model.platform_score;
    self.vipLevel.text = model.platform_level;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
