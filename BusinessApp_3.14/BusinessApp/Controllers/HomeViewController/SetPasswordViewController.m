//
//  SetPasswordViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/3.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SetPasswordViewController.h"
#import <ReactiveCocoa.h>
#import "LoginViewController.h"

@interface SetPasswordViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UISwitch *showPass;

@property (weak, nonatomic) IBOutlet UITextField *passFiled;

@property (weak, nonatomic) IBOutlet UITextField *againField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(backAction)];
    if (self.reset) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    _phoneLabel.text = [NSString stringWithFormat:@"手机号码    %@",self.phone];
    
  
    [self setSubViews];
  
    
    
    RACSignal *valid = [RACSignal combineLatest:@[_passFiled.rac_textSignal, _againField.rac_textSignal]
                                         reduce:^(NSString *account, NSString *password) {
                                             return @(account.length > 3 && password.length > 3 &&account.length == password.length && [account isEqualToString:password]);
                                         }];
    RAC(_nextBtn, enabled) = valid;
    RAC(_nextBtn, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];

}


-(void)backAction{

    UIViewController *temp = nil;
    NSArray *viewControllers = self.navigationController.viewControllers;
    temp = viewControllers[viewControllers.count -3];
    
    [self.navigationController popToViewController:temp animated:YES];

}

-(void)setSubViews{

    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];

}



- (IBAction)onSwitch:(id)sender {

    if (_showPass.on) {
        
        _passFiled.secureTextEntry = NO;
        _againField.secureTextEntry = NO;
        _showPass.on=YES;
        
    }else{
        
        _passFiled.secureTextEntry = YES;
        _againField.secureTextEntry = YES;
        _showPass.on = NO;
    }

}


- (IBAction)nextAction:(id)sender {

    if ([self.type isEqualToString:@"get"]) {
        
        
        NSLog(@"正在重置");
        _hud = [AppUtil createHUD];
        
        [AFHttpTool resetPassWord:self.phone login_pwd:_passFiled.text sms_code:self.sms_code progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            
            if (!([response[@"code"]integerValue]==0000)) {
                
                NSString *errorMessage = response [@"msg"];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                [_hud hide:YES afterDelay:3];
                
                return;
            }else{

                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                _hud.labelText = @"密码修改成功";
                [_hud hide:YES afterDelay:3];

                UIViewController *temp = nil;
                NSArray *viewControllers = self.navigationController.viewControllers;
                temp = viewControllers[viewControllers.count -4];
                
                [self.navigationController popToViewController:temp animated:YES];
                
            }
            
            
        } failure:^(NSError *err) {
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
            [_hud hide:YES afterDelay:3];
            
        }];
        
        
        
    }else{
        
        _hud = [AppUtil createHUD];
        
        [AFHttpTool registerStore:self.phone login_pwd:_passFiled.text sms_code:self.sms_code progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            
            if (!([response[@"code"]integerValue]==0000)) {
                
                NSString *errorMessage = response [@"msg"];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                [_hud hide:YES afterDelay:3];
                
                return;
            }
            
            [DEFAULTS setObject:self.phone forKey:@"userName"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            _hud.labelText = [NSString stringWithFormat:@"注册成功,请直接登录"];
            [_hud hide:YES afterDelay:2];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
 

            
        } failure:^(NSError *err) {
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
            [_hud hide:YES afterDelay:3];
            
        }];
    }
    
    
    
}

-(void)delayMethod{
    
    
    UIViewController *temp = nil;
    NSArray *viewControllers = self.navigationController.viewControllers;
    temp = viewControllers[viewControllers.count -4];
    
    [self.navigationController popToViewController:temp animated:YES];
    
    if ([temp.title isEqualToString:@"闪酒客"]) {
        
        LoginViewController *vc = [[LoginViewController alloc]init];
        
        [temp.navigationController pushViewController:vc animated:YES];
        
    }


}


-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
 
    [_hud hide:YES];
}


- (void)hidenKeyboard
{
    [_passFiled resignFirstResponder];
    [_againField resignFirstResponder];
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
