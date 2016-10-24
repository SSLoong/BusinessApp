//
//  RedDetailstCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/9/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "RedDetailstCell.h"

@implementation RedDetailstCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self createUI];
        
        [self setLayout];
        [self layoutSubviews];
    }
    
    return self;
}

- (void)createUI{
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.text = @"2016-09-22 09:05:12";
    self.timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.preferredMaxLayoutWidth = 40;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.timeLabel];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"-100";
    self.moneyLabel.textColor = [UIColor colorWithHex:0x00BB00];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.moneyLabel];
    
    self.commentLabel = [UILabel new];
    self.commentLabel.textColor = [UIColor grayColor];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.commentLabel];
}

- (void)layoutSubviews {
    //1. 执行 [super layoutSubviews];
    [super layoutSubviews];
    
    //2. 设置preferredMaxLayoutWidth: 多行label约束的完美解决
    self.timeLabel.preferredMaxLayoutWidth  = 40;
    //3. 设置preferredLayoutWidth后，需要再次执行 [super layoutSubviews];
    //其实在实际中这步不写，也不会出错，官方解释是说设置preferredLayoutWidth后需要重新计算并布局界面，所以这步最好执行
    [super layoutSubviews];
}

- (void)setLayout{
    
    [self.timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
    }];
    
    NSArray *array = [NSArray arrayWithObjects:self.timeLabel,self.moneyLabel,self.commentLabel, nil];
    
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];


}

-(void)configWithModel:(RewardListModel *)model type:(NSString *)type{
    
    self.timeLabel.text = model.time;
    self.commentLabel.text = model.memo;
    NSString *add = @"+";
    NSString *amountStr = [NSString stringWithFormat:@"%0.2f",[model.income floatValue]];
    NSString *str = [amountStr substringToIndex:1];
    if ([str isEqualToString:@"-"]) {
        self.moneyLabel.text = amountStr;
        self.moneyLabel.textColor = [UIColor colorWithHex:0x00BB00];
    }else{
        self.moneyLabel.text = [add stringByAppendingString:amountStr];
        self.moneyLabel.textColor = [UIColor redColor];
    }
}

- (void)cofigModel:(InventoryListModel *)model{

    self.timeLabel.text = model.apply_time;
    
    
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.amount];
    _timeLabel.text = model.apply_time;
    
    if ([model.status integerValue] == 2 || [model.status integerValue] == 3){
        self.commentLabel.text = @"提现失败";
    }else if ([model.status integerValue] == 4){
        self.commentLabel.text = @"提现成功";
    }else {
        self.commentLabel.text = @"提现中";
    }
}


- (void)cofigIncomeModel:(IncomeDetailModel *)model{
    self.timeLabel.text = model.create_time;
    NSString *add = @"+";
    NSString *amountStr = [NSString stringWithFormat:@"%0.2f",[model.amount floatValue]];
    NSString *str = [amountStr substringToIndex:1];
    
    if ([str isEqualToString:@"-"]) {
        self.moneyLabel.text = amountStr;
        self.moneyLabel.textColor = [UIColor colorWithHex:0x00BB00];
    }else{
        self.moneyLabel.text = [add stringByAppendingString:amountStr];
        self.moneyLabel.textColor = [UIColor redColor];
    }

    
    
    self.commentLabel.text = model.memo;
//    
//    if (model.order_id == nil) {
//        self.commentLabel.text = @"奖励";
//    }else{
//        if ([model.type integerValue] == 1) {
//            self.commentLabel.text = @"订单";
//        }else if ([model.type integerValue] == 2){
//            self.commentLabel.text = @"采购 ";
//        }else if ([model.type integerValue] == 3){
//            if ([str isEqualToString:@"-"]) {
//                self.commentLabel.text = @"红包消费";
//            }else{
//                self.commentLabel.text = @"红包退还";
//            }
//        }else if ([model.type integerValue] == 4){
//            self.commentLabel.text = @"代金券";
//        }else if (model.type.length <= 0){
//            self.commentLabel.text = @"";
//        }
//        
//    }


}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
