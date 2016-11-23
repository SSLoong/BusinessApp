//
//  FansNameCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansNameCell.h"
@interface FansNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;


@end

@implementation FansNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)remarkBtn:(id)sender {
    if (self.changeBtnBlock) {
        self.changeBtnBlock();
    }
}


- (void)configDataDic:(NSDictionary *)dic{

    self.nameLabel.text = @"孙升隆";
    self.phoneLabel.text = @"[135****1711]";
    self.sourceLabel.text = @"APP";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
