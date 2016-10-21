//
//  FansScreenVC.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansScreenVC.h"

@interface FansScreenVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *weixinBtn;

@property (nonatomic, strong) UIButton *appBtn;

@end

@implementation FansScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(FansScreenBtn:)];
    self.navigationItem.rightBarButtonItem=releaseButon;

    UIImage *image = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked)];
    self.navigationItem.leftBarButtonItem = leftButton;

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self creatUI];
    [self setLayout];
    // Do any additional setup after loading the view.
}


- (void)leftButtonClicked {
    [self.searchTextField removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)FansScreenBtn:(UIButton *)btn{
    
    if (self.searchBtnBlock) {
        self.searchBtnBlock(self.searchTextField.text);
    }
    [self.searchTextField removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)creatUI{
    
    self.searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(50.0f, 26.5f, 230.0f, 30.0f)];
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.font = [UIFont systemFontOfSize:13];
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.cornerRadius = 3.0;
    self.searchTextField.placeholder = @"   请输入用户姓名查询";
    //[self.searchTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.navigationController.view addSubview:self.searchTextField];

    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 125)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    
    self.messageLabel = [UILabel new];
    self.messageLabel.text = @"用户来源";
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.messageLabel];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    self.lineView.alpha = 0.3f;
    [self.view addSubview:self.lineView];
    
    self.weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.weixinBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.weixinBtn.layer.masksToBounds = YES;
    self.weixinBtn.layer.cornerRadius = 2.0f;
    [self.weixinBtn.layer setBorderWidth:0.1];
    self.weixinBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.weixinBtn setTitle:@"微信" forState:UIControlStateNormal];
    self. weixinBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.weixinBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.weixinBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.weixinBtn.userInteractionEnabled = YES;
    [self.weixinBtn addTarget:self action:@selector(weixinBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weixinBtn];
    
    self.appBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.appBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.appBtn.layer.masksToBounds = YES;
    self.appBtn.layer.cornerRadius = 2.0f;
    self.appBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.appBtn setTitle:@"APP" forState:UIControlStateNormal];
    self. appBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.appBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.appBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.appBtn.userInteractionEnabled = YES;
    [self.appBtn addTarget:self action:@selector(appBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.appBtn];
    

}

- (void)setLayout{
    
    
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@79);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@0);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.appBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weixinBtn.mas_right).offset(10);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
}

- (void)weixinBtnEvent:(UIButton *)btn{
    self.appBtn.selected = NO;
    self.weixinBtn.selected = YES;
    
}

- (void)appBtnEvent:(UIButton *)btn{
    self.weixinBtn.selected = NO;
    self.appBtn.selected = YES;
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
