//
//  CodeViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CodeViewController.h"
#import "PasswordEnterView.h"
#import "PasswordTextField.h"
#import <ReactiveCocoa.h>
#import "SetPasswordViewController.h"

@interface CodeViewController ()

@property (nonatomic,strong)PasswordTextField *textFieldTwo;

//@property(nonatomic,copy)NSString *sms_code;

@property(nonatomic,strong)UIButton *nextBtn;

@property(nonatomic,strong)UIButton *timeButton;

@property(nonatomic,assign)BOOL isCan;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.reset) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    self.title = @"填写验证码";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setSubViews];
    
    [self getAction];
}

-(void)setSubViews{

    
    NSMutableString *phone = [NSMutableString stringWithString:_PhoneString];
    NSString *temp = nil;
    for(int i =0; i < [_PhoneString length]; i++)
    {
        temp = [_PhoneString substringWithRange:NSMakeRange(i, 1)];

        switch (i) {
            case 3:
                [phone insertString:@" " atIndex:i];
                break;
            case 8:
                [phone insertString:@" " atIndex:i];
            default:
                break;
        }
        
        
    }
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.text=@"验证码已发送到手机：";
    messageLabel.textColor = [UIColor grayColor];
    [messageLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:12]];
    [self.view addSubview:messageLabel];
    
    UILabel *PhoneLabel = [UILabel new];
    PhoneLabel.text=phone;
    [PhoneLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:12]];
    [self.view addSubview:PhoneLabel];
    
    
    
    __weak typeof(self) weakSelf =self;
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        
        make.right.mas_equalTo(weakSelf.view.mas_centerX).offset(0.f);
        
        make.height.mas_equalTo(12);
        
    }];
    
    [PhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        
        make.left.mas_equalTo(weakSelf.view.mas_centerX).offset(2.0f);
        
        make.height.mas_equalTo(12);
        
    }];
    
    
    
    PasswordEnterView *_enterView2 = [[PasswordEnterView alloc]initWithFrame:CGRectMake([AppUtil getScreenWidth]/2-80, 96-44, 160,40) count:4 isCiphertext:NO textField:^(PasswordTextField *textField) {
        [textField becomeFirstResponder];
        _textFieldTwo = textField;
    }];
    
    
 
    
    _enterView2.textDetail = ^(NSString *textDetail){
        
       
        if (textDetail.length == 4) {
            
            _nextBtn.userInteractionEnabled = YES;
            _nextBtn.alpha = 1.0f;

        }else{
        
            _nextBtn.userInteractionEnabled = NO;
            _nextBtn.alpha = 0.4f;
        }
    };

    
    _enterView2.layer.cornerRadius = 10;
    [_enterView2 setBackgroundColor:[UIColor colorWithHex:0xFFFFFF]];
    
    [self.view addSubview:_enterView2];
    


    _nextBtn = [UIButton new];
    [_nextBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.layer.cornerRadius = 3;
    _nextBtn.userInteractionEnabled = NO;
    _nextBtn.alpha = 0.4f;
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    
    
    _timeButton = [UIButton new];
    _timeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_timeButton setTitle:@"重新获取验证码(60)" forState:UIControlStateNormal];
    [_timeButton.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:12]];
    _timeButton.userInteractionEnabled = NO;
    [_timeButton addTarget:self action:@selector(getAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeButton];
  
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(175-44-20);
        
        make.left.mas_equalTo(10);
        
        make.right.mas_equalTo(-10);
        
        make.height.mas_equalTo(36);
        
    }];
    
    [_timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(212-44);
        
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        
        make.height.mas_equalTo(12);
        
    }];
    
    
}


-(void)nextAction:(id)sender{
    
    
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"SetPassword" bundle:nil];
        
        SetPasswordViewController *ctrlVc = [story instantiateViewControllerWithIdentifier:@"SetPasswordVc"];
    
        ctrlVc.phone = self.PhoneString;
        
        ctrlVc.type = self.type;
    
        ctrlVc.sms_code = _textFieldTwo.text;
    
        ctrlVc.reset = self.reset;
        
        [self.navigationController pushViewController:ctrlVc animated:YES];

}





-(void)getAction{

    
    if (_isCan) {

        if (![self.type isEqualToString:@"set"]) {
            
            
            _hud = [AppUtil createHUD];
            
            _hud.userInteractionEnabled = YES;
            
            _hud.labelText = @"正在发送验证码...";
            
            [AFHttpTool findpwdCode:_PhoneString progress:^(NSProgress *progress) {
                
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
        
        [AFHttpTool getCodePhone:_PhoneString progress:^(NSProgress *progress) {
            
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
            
        } failure:^(NSError *err) {
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = @"发送验证码失败,请重新获取!";
            [_hud hide:YES afterDelay:2];
        
        }];
            
        }

        
    }

    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_timeButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                [_timeButton setTitleColor:[UIColor colorWithHex:0xFD5B44] forState:UIControlStateNormal];
                _timeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_timeButton setTitle:[NSString stringWithFormat:@"重新获取验证码(%@)",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                [_timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                _timeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    _isCan = YES;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFieldTwo resignFirstResponder];
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
