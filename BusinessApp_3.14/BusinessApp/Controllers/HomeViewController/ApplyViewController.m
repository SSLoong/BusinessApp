//
//  ApplyViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ApplyViewController.h"
#import <ReactiveCocoa.h>
#import "CodeViewController.h"

@interface ApplyViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITextField *accountField;

@property(nonatomic,strong)UIButton *nextBtn;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.reset) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    self.title = @"手机号码";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setSubViews];
    
    RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal]
                                         reduce:^(NSString *account) {
                                             return @(account.length > 10);
                                         } ];
    RAC(_nextBtn, enabled) = valid;
    RAC(_nextBtn, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
}


-(void)setSubViews{

    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UILabel *PhoneLabel = [UILabel new];
    PhoneLabel.text=@"手机号码";
    [PhoneLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [bgView addSubview:PhoneLabel];
    
  
    _accountField = [UITextField new];
    _accountField.keyboardType = UIKeyboardTypeNumberPad;
    _accountField.font = [UIFont systemFontOfSize:14];
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountField.placeholder = @"请输入手机号码";
    _accountField.delegate = self;
    [_accountField becomeFirstResponder];
    [bgView addSubview:_accountField];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    
    _nextBtn = [UIButton new];
    [_nextBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.layer.cornerRadius = 3;
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];

    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo([AppUtil getScreenWidth]);
        
        make.height.mas_equalTo(41);
        
        make.left.mas_equalTo(0);
        
        make.top.mas_equalTo(20);
    }];
    
    [PhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_top).offset(13);
        
        make.left.mas_equalTo(20);
        
        make.height.mas_equalTo(14);
        
    }];
    

    [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView.mas_left).offset(97.f);
        
        make.top.equalTo(bgView.mas_top).offset(14.f);
        
        make.height.mas_equalTo(14);
        
        make.right.equalTo(bgView.mas_right).offset(-10.f);
        
        
    }];
    
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgView.mas_bottom).offset(20.f);
        
        make.left.mas_equalTo(10);
        
        make.right.mas_equalTo(-10);
        
        make.height.mas_equalTo(36);
        
    }];
    
    
    
}


-(void)nextAction:(id)sender{
    
    if ([self.type isEqualToString:@"set"]) {
        
        _hud = [AppUtil createHUD];
        
        _hud.userInteractionEnabled = YES;
        
        _hud.labelText = @"正在发送验证码...";
        
        [AFHttpTool getCodePhone:_accountField.text progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            
            if (!([response[@"code"]integerValue]==0000)) {
                
                NSString *errorMessage = response [@"msg"];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                [_hud hide:YES afterDelay:3];
                
                return;
            }
            
            [_hud hide:YES];
            
            CodeViewController *codeVc = [[CodeViewController alloc]init];
            
            codeVc.PhoneString = _accountField.text;
            
            codeVc.type = self.type;
            
            codeVc.reset = self.reset;
            
            [self.navigationController pushViewController:codeVc animated:YES];
            
            
        } failure:^(NSError *err) {
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = @"发送验证码失败,请重新获取!";
            [_hud hide:YES afterDelay:2];
            
        }];
        

    }else{
    
        
        _hud = [AppUtil createHUD];
        
        _hud.userInteractionEnabled = YES;
        
        _hud.labelText = @"正在发送验证码...";
        
        [AFHttpTool findpwdCode:_accountField.text progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            
            if (!([response[@"code"]integerValue]==0000)) {
                
                NSString *errorMessage = response [@"msg"];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                [_hud hide:YES afterDelay:3];
                
                return;
            }
            
            [_hud hide:YES];
            
            CodeViewController *codeVc = [[CodeViewController alloc]init];
            
            codeVc.PhoneString = _accountField.text;
            
            codeVc.type = self.type;
            
            codeVc.reset = self.reset;
            
            [self.navigationController pushViewController:codeVc animated:YES];
            
            
        } failure:^(NSError *err) {
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = @"发送验证码失败,请重新获取!";
            [_hud hide:YES afterDelay:2];
            
        }];
    
    
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_hud hide:YES];

}


#pragma mark -键盘操作
- (void)hidenKeyboard
{
    [_accountField resignFirstResponder];
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
