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
    
    self.discountLabel.backgroundColor = [UIColor colorWithHex:0Xfd654e];
    self.discountLabel.textColor = [UIColor whiteColor];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.discountLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.discountLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.discountLabel.layer.mask = maskLayer;

    self.moneyLabel.backgroundColor = [UIColor whiteColor];
    self.moneyLabel.textColor = [UIColor  colorWithHex:0Xfd654e];
    
    
    self.moneyLabel.layer.borderColor = [UIColor redColor].CGColor;//边框颜色,要为CGColor
    self.moneyLabel.layer.borderWidth = 0.5f;//边框宽度
    self.moneyLabel.layer.masksToBounds = YES;
    self.moneyLabel.layer.cornerRadius = 5;

    // Initialization code
}

- (void)configDataModel:(GoodsStateModel *)model{
    self.nameLabel.text = model.activity_name;
    self.discountLabel.text = model.strategy;
    self.moneyLabel.text =  [NSString stringWithFormat:@" %@元",model.sub_amount];
    
    NSString *startTime = [model.start_time substringToIndex:10];
    NSString *endTime = [model.end_time substringToIndex:10];
    
    
    self.timeLabelOne.text = startTime;
    self.timeLabelTwo.text = endTime;
    NSString *num = [NSString stringWithFormat:@"已推送%@人",model.cust_num];
    self.peopleNum.text = num;

}

- (IBAction)pushNumEvent:(id)sender {
    if (self.PushTapBlock) {
        self.PushTapBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
