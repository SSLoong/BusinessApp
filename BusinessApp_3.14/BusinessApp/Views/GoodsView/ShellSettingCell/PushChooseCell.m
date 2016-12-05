//
//  PushChooseCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PushChooseCell.h"

@interface PushChooseCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *money_vip_Label;

@property (weak, nonatomic) IBOutlet UILabel *store_vip_label;

@property (weak, nonatomic) IBOutlet UILabel *sellNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *checkImgaeView;


@end


@implementation PushChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PushChooseModel *)model {
    
    _model = model;

    self.checkImgaeView.image = _model.isSelected ? [UIImage imageNamed:@"ico-suc"] : [UIImage imageNamed:@"choosebox"];
    self.nameLabel.text = _model.memo;
    self.phoneLabel.text = _model.phone;
    self.money_vip_Label.text = _model.platform_level;
    self.store_vip_label.text = _model.store_level;
    self.sellNumLabel.text = _model.buy_num;
    
}



- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        _checkImgaeView.image = [UIImage imageNamed:@"ico-suc"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        _checkImgaeView.hidden = YES;
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
