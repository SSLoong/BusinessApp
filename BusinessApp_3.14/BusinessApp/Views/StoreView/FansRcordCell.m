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
        make.left.mas_equalTo(@15);
    }];
    
    [self configDictionary:self.dic];
    
    // Initialization code
}

- (void)configDictionary:(NSDictionary *)dic{
    
    NSArray *colorArr = [[NSArray alloc]init];
    if (dic) {
        colorArr = @[[UIColor blackColor]];
    }else if (dic){
        colorArr = @[[UIColor blackColor],[UIColor blackColor]];
    }else if (dic){
        colorArr = @[[UIColor blackColor],[UIColor blackColor],[UIColor grayColor]];
    }else if (dic){
        colorArr = @[[UIColor blackColor],[UIColor blackColor],[UIColor grayColor],[UIColor grayColor]];
    }else{
        colorArr = @[[UIColor blackColor],[UIColor blackColor],[UIColor grayColor],[UIColor grayColor],[UIColor lightGrayColor]];
    }
    
    
    NSString *a = @"13781213137";
    NSString *string=[a stringByReplacingOccurrencesOfString:[a substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    NSLog(@"b:%@",string);
    
    NSString *phoneString = [NSString stringWithFormat:@"[%@]",string];
    
    self.name.text = @"散客";
    self.phone.text = phoneString;
    self.sotreLevel.text = @"2";
    self.consumeLevel.text = @"5";
  
    self.tagsView.tagStrings = @[@"茅台", @"五粮液", @"剑南春",@"洋河",@"汾酒"];
    self.tagsView.tagColors = @[[UIColor blackColor],[UIColor blackColor],[UIColor grayColor],[UIColor grayColor],[UIColor lightGrayColor]];

    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
