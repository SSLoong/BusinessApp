//
//  HomeViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "ApplyViewController.h"
#import "PostDataTableViewController.h"




@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"闪酒客";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setSubViews];
    
}


-(void)setSubViews{
    
    UIImageView *loginImage = [UIImageView new];
    loginImage.contentMode = UIViewContentModeScaleAspectFit;
    loginImage.image = [UIImage imageNamed:@"Logo"];
    [loginImage setCornerRadius:40];
    [self.view addSubview:loginImage];
    
    UIButton *loginBtn = [UIButton new];
    [loginBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [loginBtn setTitle:@"立刻登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *comeBtn = [UIButton new];
    [comeBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [comeBtn setTitle:@"申请入驻" forState:UIControlStateNormal];
    comeBtn.layer.cornerRadius = 3;
    [comeBtn addTarget:self action:@selector(comeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comeBtn];
    
    CGFloat h = ([AppUtil getScreenHeight]-64)*95/667;
    
    CGFloat h1 = ([AppUtil getScreenHeight]-64)/2-46;
    
    __weak typeof(self) weakSelf = self;
    
    [loginImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(80, 80));
        
        make.left.equalTo(weakSelf.view.mas_centerX).offset(-40);
        
        make.top.mas_equalTo(h);
        
    }];
    
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(h1);
        
        make.left.mas_equalTo(20);
        
        make.right.mas_equalTo(-20);
        
        make.height.mas_equalTo(36);
        
    }];
    
    
    [comeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.left.right.equalTo(loginBtn);
        
        make.top.equalTo(loginBtn.mas_bottom).offset(20);
    }];
    
};

-(void)loginAction:(id)sender{

    LoginViewController *vc= [[LoginViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)comeAction:(id)sender{


    ApplyViewController *vc = [[ApplyViewController alloc]init];
    
    vc.type = @"set";
    
    [self.navigationController pushViewController:vc animated:YES];


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
