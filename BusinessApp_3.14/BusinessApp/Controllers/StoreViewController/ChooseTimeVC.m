//
//  ChooseTimeVC.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ChooseTimeVC.h"

@interface ChooseTimeVC ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *mouthBtn;

@property (nonatomic, strong) UIButton *lastMouthBtn;

@property (nonatomic, strong) UIButton *yearBtn;

@property (nonatomic, strong) UIButton *lastYearBtn;

@property (nonatomic, strong) UIButton *AllBtn;


@end

@implementation ChooseTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择时间";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)creatUI{

    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 125)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];

    
    NSArray *nameArr = [NSArray arrayWithObjects:@"本月",@"上月",@"今年",@"去年",@"全部", nil];
    for (int i = 0; i < 5 ; i++) {
    
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timeBtn.frame = CGRectMake(ScreenWidth/5*i + 10 , 124 , ScreenWidth/5 - 20, 25);
        timeBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        timeBtn.layer.masksToBounds = YES;
        timeBtn.layer.cornerRadius = 2.0f;
        [timeBtn.layer setBorderWidth:0.1];
        timeBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [timeBtn setTitle: nameArr[i] forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        timeBtn.userInteractionEnabled = YES;
        timeBtn.tag = i;
        [timeBtn addTarget:self action:@selector(timeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:timeBtn];
    }
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.text = @"日期";
    messageLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:messageLabel];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@79);
        
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    
}


- (void)timeBtnEvent:(int)tag{
    if (self.chooseTimeBlock) {
        self.chooseTimeBlock(tag);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
