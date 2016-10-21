//
//  AddManagerViewController.m
//  BusinessApp
//
//  Created by perfect on 16/3/31.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AddManagerViewController.h"

@interface AddManagerViewController ()


@property(nonatomic,strong)UIView * allView;



@property(nonatomic,strong)UILabel * phoneNum;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIView * lineView;



@property(nonatomic,strong)UILabel * pwd;

@property(nonatomic,strong)UITextField * textField2;

@property(nonatomic,strong)UIView * line2View;



@property(nonatomic,strong)UILabel * yPwd;

@property(nonatomic,strong)UITextField * textField4;



@property(nonatomic,strong)UIButton * rePwd;

@property(nonatomic,strong)UIButton * btn;





@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)BOOL isCan;

@end

@implementation AddManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增操作员";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initSubview];
    [self setLayout];
}

-(void)initSubview{
    
    _allView = [UIView new];
    _allView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_allView];
    
    _phoneNum = [UILabel new];
    _phoneNum.text = @"手机号码";
    _phoneNum.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_phoneNum];
    
    _textField = [UITextField new];
    _textField.placeholder = @"请输入操作员手机号";
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_allView addSubview:_textField];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_allView addSubview:_lineView];

    _pwd = [UILabel new];
    _pwd.text = @"登录密码";
    _pwd.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_pwd];
    
    _textField2 = [UITextField new];
    _textField2.placeholder = @"请输入4-11位登录密码";
    _textField2.font = [UIFont systemFontOfSize:14];
    _textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField2.keyboardType = UIKeyboardTypeASCIICapable;
    _textField2.secureTextEntry = YES;
    [_allView addSubview:_textField2];
    
    _line2View = [UIView new];
    _line2View.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_allView addSubview:_line2View];

    

    _yPwd = [UILabel new];
    _yPwd.text = @"验证码";
    _yPwd.textColor = [UIColor blackColor];
    _yPwd.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_yPwd];
    
    
    _textField4 = [UITextField new];
    _textField4.placeholder = @"请输入验证码";
    _textField4.keyboardType = UIKeyboardTypeNumberPad;
    _textField4.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField4.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_textField4];
    
    _rePwd = [UIButton new];
    [_rePwd setTitle:@" 发送验证码 " forState:UIControlStateNormal];
    [_rePwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rePwd setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    _rePwd.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rePwd addTarget:self action:@selector(getAction:) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_rePwd];
    
    _btn = [UIButton new];
    [_btn setTitle:@"确认新增" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    _btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btn addTarget:self action:@selector(appendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];

    
}
-(void)setLayout{

    [_allView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width,135));
    }];
    [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(86);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(15.f);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    [_textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom);
        make.left.mas_equalTo(86);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    [_line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwd.mas_bottom).offset(15.f);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    
    [_yPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_line2View.mas_bottom).offset(15.f);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    [_textField4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_line2View.mas_bottom);
        make.left.mas_equalTo(86);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(44);
    }];
    [_rePwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(90, 45));
    }];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allView.mas_bottom).offset(15.f);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
        
    }];
}

-(void)getAction:(id)sender{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
    _hud.labelText = @"正在发送验证码...";
    
    [AFHttpTool SmsauthAddOperator:_textField.text progress:^(NSProgress *progress) {
        
    } success:^(id response) {

        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hud.labelText = @"验证码发送成功";
        [_hud hide:YES afterDelay:1];
        NSLog(@"%@",response);
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = @"发送验证码失败,请重新获取!";
        [_hud hide:YES afterDelay:2];
        
    }];
 
}


-(void)appendAction:(id)sender{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
    _hud.labelText = @"正在添加";
    
    [AFHttpTool StoreAddoperator:_textField.text
                        store_id:Store_id
                       login_pwd:_textField2.text
                        sms_code:_textField4.text
                        progress:^(NSProgress *progress) {
        
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
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = @"添加失败,请重新添加!";
        [_hud hide:YES afterDelay:2];
        
    }];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        [_textField resignFirstResponder];
        [_textField2 resignFirstResponder];
        [_textField4 resignFirstResponder];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
