//
//  WithdrawDetailCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/17.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "WithdrawDetailCell.h"

@implementation WithdrawDetailCell

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
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timeLabel];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.text = @"-100";
    self.moneyLabel.textColor = [UIColor colorWithRed:253.0/255.0 green:65.0/255.0 blue:47.0/255.0 alpha:1.0f];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.moneyLabel];
    
    self.commentLabel = [UILabel new];
    self.commentLabel.textColor = [UIColor grayColor];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    self.commentLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.commentLabel];
    
    self.remarkLabel = [UILabel new];
    self.remarkLabel.textColor = [UIColor grayColor];
    self.remarkLabel.numberOfLines = 0;
    self.remarkLabel.textAlignment = NSTextAlignmentCenter;
    self.remarkLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.remarkLabel];

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
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
    }];
    
    NSArray *array = [NSArray arrayWithObjects:self.timeLabel,self.moneyLabel,self.commentLabel,self.remarkLabel, nil];
    
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
    
}

- (void)cofigModel:(InventoryListModel *)model{
    
    self.timeLabel.text = model.apply_time;
    NSString *amountStr = [NSString stringWithFormat:@"%0.2f",[model.amount floatValue]];

    _moneyLabel.text = amountStr;
    _timeLabel.text = model.apply_time;
    
    
    if ([model.status integerValue] == 2 || [model.status integerValue] == 3){
        self.commentLabel.text = @"提现失败";
    }else if ([model.status integerValue] == 4){
        self.commentLabel.text = @"提现成功";
    }else {
        self.commentLabel.text = @"提现中";
    }
    
    self.remarkLabel.text = model.remark;
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
