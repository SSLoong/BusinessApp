//
//  LoginViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "LoginViewController.h"
#import "ApplyViewController.h"
#import <ReactiveCocoa.h>
#import "PostDataTableViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITextField *accountField;

@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UIButton *loginBtn;

@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic,copy)NSString *store_id;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setSubViews];
    
    
    RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal, _passwordField.rac_textSignal]
                                         reduce:^(NSString *account, NSString *password) {
                                             return @(account.length > 10 && password.length > 3);
                                         }];
    RAC(_loginBtn, enabled) = valid;
    RAC(_loginBtn, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
}

-(void)setSubViews{

    UIImageView *logo = [UIImageView new];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [UIImage imageNamed:@"Logo"];
    [logo setCornerRadius:30];
    [self.view addSubview:logo];

    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:lineView];
    
    
    UILabel *PhoneLabel = [UILabel new];
    PhoneLabel.text=@"手机号码";
    [PhoneLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [bgView addSubview:PhoneLabel];
    
    UILabel *PassLabel = [UILabel new];
    PassLabel.text=@"密码";
    [PassLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [bgView addSubview:PassLabel];
    
    _accountField = [UITextField new];
    _passwordField = [UITextField new];
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.font = [UIFont systemFontOfSize:14];
    _passwordField.font = [UIFont systemFontOfSize:14];
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.returnKeyType = UIReturnKeyGo;
    _passwordField.secureTextEntry = YES;
    _accountField.placeholder = @"请输入手机号码";
    _passwordField.placeholder = @"请输入密码";
    _accountField.delegate = self;
    _passwordField.delegate = self;
    _accountField.text = [self getDefaultUserName];
    [bgView addSubview:_accountField];
    [bgView addSubview:_passwordField];
    
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    

    

    _loginBtn = [UIButton new];
    [_loginBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 3;
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    UIButton *getBtn = [UIButton new];
    [getBtn setTitleColor:[UIColor colorWithHex:0xFD5B44] forState:UIControlStateNormal];
    [getBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [getBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [getBtn addTarget:self action:@selector(getAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    
    
    UIButton *comeBtn = [UIButton new];
    [comeBtn setTitleColor:[UIColor colorWithHex:0xFD5B44] forState:UIControlStateNormal];
    [comeBtn setTitle:@"申请入驻" forState:UIControlStateNormal];
    [comeBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [comeBtn addTarget:self action:@selector(comeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comeBtn];
    
    
    __weak typeof(self) weakSelf = self;
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(60, 60));
        
        make.left.equalTo(weakSelf.view.mas_centerX).offset(-30);
        
        make.top.mas_equalTo(20);
        
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo([AppUtil getScreenWidth]);
        
        make.height.mas_equalTo(81);
        
        make.left.mas_equalTo(0);
        
        make.top.equalTo(logo.mas_bottom).offset(20);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1);
        
        make.left.mas_equalTo(20);
        
        make.right.mas_equalTo(0);
        
        make.centerY.equalTo(bgView.mas_centerY).offset(0.f);
        
    }];
    
    
    [PhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(bgView.mas_top).offset(13);
        
        make.left.mas_equalTo(20);
        
        make.height.mas_equalTo(14);
        
    }];
    
    [PassLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(bgView.mas_top).offset(54);
        
        make.height.left.equalTo(PhoneLabel);
        
    }];
    
    
    
    
    [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bgView.mas_left).offset(97.f);
        
        make.top.equalTo(bgView.mas_top).offset(14.f);
        
        make.height.mas_equalTo(14);
        
        make.right.equalTo(bgView.mas_right).offset(-10.f);
        
        
    }];
    
    
 
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top).offset(54.f);
        
        make.height.width.left.right.equalTo(_accountField);
        
    }];
    
    

    
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_bottom).offset(20.f);
        
        make.left.mas_equalTo(10);
        
        make.right.mas_equalTo(-10);
        
        make.height.mas_equalTo(36);
        
    }];
    
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        
        make.top.equalTo(_loginBtn.mas_bottom).offset(13.f);
        
        make.height.mas_equalTo(14);
    }];
    
    [comeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        
        make.top.width.height.equalTo(getBtn);
    }];
    
    
    
    

}


-(void)viewDidDisappear:(BOOL)animated{


    [super viewDidDisappear:animated];
    
    [_hud hide:YES];
    
}


-(void)loginAction:(id)sender{


    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在登录...";
    _hud.userInteractionEnabled = NO;

    [AFHttpTool LoginWithPhone:_accountField.text pwd:_passwordField.text progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }


        if([response[@"data"][@"auth"]integerValue] == 1){
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            _hud.labelText = @"登录成功";
            [_hud hide:YES afterDelay:3];
            
            [DEFAULTS setBool:YES forKey:@"isLogin"];
            
            if ([response[@"data"][@"admin"]integerValue] == 1) {
                
                [DEFAULTS setBool:YES forKey:@"isAdmin"];
            }else{
            
                [DEFAULTS setBool:NO forKey:@"isAdmin"];
            }

            [DEFAULTS setObject:_accountField.text forKey:@"userName"];
            [DEFAULTS setObject:_passwordField.text forKey:@"passWord"];
            [DEFAULTS setObject:response[@"data"][@"type"] forKey:@"store_type"];
            [DEFAULTS setObject:response[@"data"][@"store_id"] forKey:@"store_id"];
            [DEFAULTS synchronize];
            WYBLog(@"%@",response);
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UINavigationController *rootNavi = [storyboard instantiateViewControllerWithIdentifier:@"rootNavi"];
                    [ShareApplicationDelegate window].rootViewController = rootNavi;
                            
                        });
    
        }else{
        

            if ([response[@"data"][@"step"]integerValue] == 1) {
                
                self.store_id = response[@"data"][@"store_id"];
                
                [self addData];
                
            }else if([response[@"data"][@"step"]integerValue] == 2){
            
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = @"温馨提示:";
                _hud.detailsLabelText = @"资料审核失败,请重新填写资料";
                [_hud hide:YES afterDelay:2];

                self.store_id = response[@"data"][@"store_id"];
                
                [self performSelector:@selector(addData) withObject:nil afterDelay:2.0f];
        
            }else{
            
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-warn"]];
                _hud.labelText = @"温馨提示:";
                _hud.detailsLabelText = @"资料正在审核中,审核通过后我们会以短信方式通知您";
                [_hud hide:YES afterDelay:3];
                
            }

        }


    } failure:^(NSError *err) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    
    
    
}



-(void)addData{


    UIStoryboard *story = [UIStoryboard storyboardWithName:@"PostData" bundle:nil];
    
    PostDataTableViewController *ctrlVc = [story instantiateViewControllerWithIdentifier:@"PostDataTableViewController"];
    
    ctrlVc.store_id = self.store_id;
    
    [self.navigationController pushViewController:ctrlVc animated:YES];

}


-(void)getAction:(id)sender{
    
    ApplyViewController *applyVC = [[ApplyViewController alloc]init];
    
    applyVC.type = @"get";
    
    [self.navigationController pushViewController:applyVC animated:YES];


}


-(void)comeAction:(id)sender{

    ApplyViewController *applyVC = [[ApplyViewController alloc]init];
    
    applyVC.type = @"set";
    
    [self.navigationController pushViewController:applyVC animated:YES];
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [_hud hide:YES];
//}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    if (textField == _accountField) {
        [DEFAULTS removeObjectForKey:@"userName"];
        _accountField.text = nil;
    }
    return YES;
}



- (NSString*)getDefaultUserName
{
    NSString* defaultUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    return defaultUser;
}

#pragma mark - 键盘操作

- (void)returnOnKeyboard:(UITextField *)sender
{
    
 if (sender == _passwordField) {

     [self hidenKeyboard];
     if (_loginBtn.enabled) {

         [self loginAction:self];
         
     }

 }
}

- (void)hidenKeyboard
{
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

#pragma mark - textField的代理方法

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _accountField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
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
