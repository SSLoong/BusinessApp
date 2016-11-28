//
//  ShellListCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ShellListCell.h"

@interface ShellListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabelOne;

@property (weak, nonatomic) IBOutlet UILabel *timeLabelTwo;

@property (weak, nonatomic) IBOutlet UILabel *peopleNum;



@end


@implementation ShellListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.discountLabel.backgroundColor = [UIColor redColor];
    self.discountLabel.textColor = [UIColor whiteColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.discountLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.discountLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.discountLabel.layer.mask = maskLayer;

    self.moneyLabel.backgroundColor = [UIColor whiteColor];
    self.moneyLabel.textColor = [UIColor redColor];
    
    
    self.moneyLabel.layer.borderColor = [UIColor redColor].CGColor;//边框颜色,要为CGColor
    self.moneyLabel.layer.borderWidth = 0.5f;//边框宽度
    self.moneyLabel.layer.masksToBounds = YES;
    self.moneyLabel.layer.cornerRadius = 5;

    // Initialization code
}

- (void)configDataModel:(NSDictionary *)model{
    self.nameLabel.text = @"不是给谁一瓶雪花，都能陪你勇闯天涯";
    self.discountLabel.text = @"满赠";
    self.moneyLabel.text = @"9999元";
    
    self.peopleNum.text = @"已推送39人";


}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
