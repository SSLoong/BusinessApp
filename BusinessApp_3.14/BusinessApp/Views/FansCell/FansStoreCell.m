//
//  FansStoreCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansStoreCell.h"

@interface FansStoreCell ()

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *vipLevel;

@end

@implementation FansStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configDataDic:(NSDictionary *)dic{
    self.money.text = @"¥54321";
    self.vipLevel.text = @"8";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
