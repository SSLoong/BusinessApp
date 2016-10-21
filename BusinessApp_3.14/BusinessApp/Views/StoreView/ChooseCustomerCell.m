//
//  ChooseCustomerCell.m
//  BusinessApp
//
//  Created by wangyebin on 16/9/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ChooseCustomerCell.h"

@interface ChooseCustomerCell ()
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation ChooseCustomerCell
- (IBAction)chooseAction:(id)sender {
    
    if (self.buttonBlock) {
        
        NSString *name = self.dataDic[@"memo"];
        NSString *phone = self.dataDic[@"phone"];
        self.buttonBlock(name,phone);
    }
}

- (void)awakeFromNib {
    // Initialization code
    
    [self.chooseBtn setCornerRadius:12.5];
    
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.phoneLab.text = _dataDic[@"phone"];
    self.nameLab.text = _dataDic[@"memo"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
