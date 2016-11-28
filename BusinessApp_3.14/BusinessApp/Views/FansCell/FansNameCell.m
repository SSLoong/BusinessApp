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


- (void)configFansInfoModel:(FansInfoModel *)model{

    self.nameLabel.text = model.memo;
    self.phoneLabel.text = model.phone;
    self.sourceLabel.text = model.source;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
