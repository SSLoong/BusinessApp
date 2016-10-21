//
//  OrderSureController.m
//  BusinessApp
//
//  Created by prefect on 16/3/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderSureController.h"

@interface OrderSureController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UITextField *codeField;


@end

@implementation OrderSureController

- (void)viewDidLoad {
    [super viewDidLoad];

    _phoneLabel.text = [NSString stringWithFormat:@"请输入用户%@的动态验证码",self.buyPhone];
    
    [_codeField becomeFirstResponder];

}



- (IBAction)sureAction:(id)sender {
    
    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = @"请稍等...";
    [AFHttpTool orderCodeConfirm:self.order_id sms_code:_codeField.text cust_id:self.cust_id progress:^(NSProgress *progress) {
        
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
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    } failure:^(NSError *err) {
        
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
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
