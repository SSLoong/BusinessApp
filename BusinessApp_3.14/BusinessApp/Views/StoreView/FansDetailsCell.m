//
//  FansDetailsCell.m
//  BusinessApp
//
//  Created by wangyebin on 16/9/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansDetailsCell.h"

@interface FansDetailsCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *coutLab;
@property (weak, nonatomic) IBOutlet UILabel *spendLab;
@end




@implementation FansDetailsCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    self.timeLab.text  = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
    self.sourceLab.text = [NSString stringWithFormat:@"%@",dic[@"source"]];
    self.spendLab.text = [NSString stringWithFormat:@"￥%@",dic[@"real_amount"]];
    self.coutLab.text = [NSString stringWithFormat:@"%@",dic[@"total_goods"]];
}
  

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
