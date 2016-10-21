//
//  FeedbackViewController.m
//  BusinessApp
//
//  Created by perfect on 16/4/6.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SettingViewController.h"
@interface FeedbackViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UILabel * lable;

@property(nonatomic,strong)UITextView * textView;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIAlertView * alert;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"建议反馈";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createView];
}

-(void)createView{
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 74, 14)];
    titleLabel.text = @"问题与意见";
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:titleLabel];
    
    UIView * allView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, 125)];
    allView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:allView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 104, self.view.bounds.size.width-20, 60)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 185, self.view.bounds.size.width-10, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineView];
    
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 74, 14)];
    phoneLabel.text = @"联系电话";
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textColor = [UIColor blackColor];
    [self.view addSubview:phoneLabel];
    
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(74, 198, self.view.bounds.size.width-100, 20)];
    _textField.placeholder = @"选填 , 便于我们与您联系";
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_textField];
    
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 240, self.view.bounds.size.width-20, 36)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)addAction:(UIButton *)btn{
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在提交...";
    _hud.userInteractionEnabled = NO;
    
    if (_textView.text.length == 0) {
        

        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"要反馈的内容不能为空"];
        [_hud hide:YES afterDelay:2];
        
        return;
    }
    
    
    [AFHttpTool feedback:LoginPhone feedback_content:_textView.text contact_mode:_textField.text store_id:Store_id progress:^(NSProgress *progress) {
        
        
    } success:^(id response) {
        

        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:5];
            
            return;
        }
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hud.labelText = @"温馨提示:";
        _hud.detailsLabelText = @"反馈成功,感谢您的支持";
        [_hud hide:YES afterDelay:4];
        
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
    }];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([_textView.text isEqualToString:@"请简要描述您的问题和意见"]) {
        _textView.textColor = [UIColor lightGrayColor];
        _textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (_textView.text.length < 1) {
        _textView.textColor = [UIColor lightGrayColor];
        _textView.text = @"请简要描述您的问题和意见";
    }
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
