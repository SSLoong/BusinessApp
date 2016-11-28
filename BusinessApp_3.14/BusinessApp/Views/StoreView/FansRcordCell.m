//
//  FansRcordCell.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansRcordCell.h"
#import "BENTagsView.h"
@interface FansRcordCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *sotreLevel;

@property (weak, nonatomic) IBOutlet UILabel *consumeLevel;

@property (nonatomic, strong) BENTagsView *tagsView;

@end

@implementation FansRcordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tagsView = [[BENTagsView alloc] init];
    self.tagsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tagsView setTagCornerRadius:9];
    self.tagsView.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.tagsView];

    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(@-13);
        make.left.mas_equalTo(@10);
    }];
    
    // Initialization code
}

- (void)configDataModel:(FansRewardModel *)modle{
    
    NSArray *colorArr = [[NSArray alloc]init];
    if (modle.brands.count == 1) {
        colorArr = @[[UIColor colorWithHex:323232]];
    }else if (modle.brands.count == 2){
        colorArr = @[[UIColor colorWithHex:323232],[UIColor colorWithHex:555555]];
    }else if (modle.brands.count == 3){
        colorArr = @[[UIColor colorWithHex:323232],[UIColor colorWithHex:555555],[UIColor colorWithHex:787878]];
    }else if (modle.brands.count == 4){
        colorArr = @[[UIColor colorWithHex:323232],[UIColor colorWithHex:555555],[UIColor colorWithHex:787878],[UIColor colorWithHex:0x9b9b9b]];
    }else{
        colorArr = @[[UIColor colorWithHex:323232],[UIColor colorWithHex:555555],[UIColor colorWithHex:787878],[UIColor colorWithHex:0x9b9b9b],[UIColor colorWithHex:0xbebebe]];
    }

    self.name.text = modle.memo;
    self.phone.text = modle.phone;
    self.sotreLevel.text = modle.store_level;
    self.consumeLevel.text = modle.platform_level;
  
    self.tagsView.tagStrings = modle.brands;
    self.tagsView.tagColors = @[[UIColor blackColor],[UIColor blackColor],[UIColor grayColor],[UIColor grayColor],[UIColor lightGrayColor]];

    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
