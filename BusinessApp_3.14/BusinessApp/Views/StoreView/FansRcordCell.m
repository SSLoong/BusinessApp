//
//  FansRcordCell.m
//  BusinessApp
//
//  Created by wangyebin on 16/8/19.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansRcordCell.h"

@interface FansRcordCell ()

@property (weak, nonatomic) IBOutlet UILabel *fans;

@property (weak, nonatomic) IBOutlet UILabel *souce;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *order;

@property (weak, nonatomic) IBOutlet UILabel *spend;

@end


@implementation FansRcordCell

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    self.fans.text  = [NSString stringWithFormat:@"%@",dic[@"phone"]];
    self.souce.text = [NSString stringWithFormat:@"%@",dic[@"source"]];
    self.order.text = [NSString stringWithFormat:@"%@",dic[@"buy_num"]];
    self.spend.text = [NSString stringWithFormat:@"￥%@",dic[@"buy_amount"]];
    NSString * str =  [NSString stringWithFormat:@"%@",dic[@"memo"]];
    if ([str isEqualToString:@""]) {
        self.name.backgroundColor = RGB(253, 134, 7);
        [self.name setCornerRadius:self.name.frame.size.height/2.0];
        self.name.text = @"备注";
        //self.name.textColor = [UIColor whiteColor];
        self.name.userInteractionEnabled = YES;
    }else{
        self.name.text = str;
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textColor =[UIColor blackColor];
        self.name.userInteractionEnabled = YES;
    }
    
    
    


}


- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAction)];
    [self.name addGestureRecognizer:tap];
    
    UITapGestureRecognizer * details_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailes)];
    [self.contentView addGestureRecognizer:details_tap];
    
    
    
    
}

- (void)addAction
{
    if (self.buttonBlcok) {
        self.buttonBlcok();
    }
}


- (void)detailes
{
    if (self.detailsBlcok) {
        self.detailsBlcok();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
