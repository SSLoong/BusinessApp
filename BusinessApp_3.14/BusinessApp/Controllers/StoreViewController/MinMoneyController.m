//
//  MinMoneyController.m
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MinMoneyController.h"

@interface MinMoneyController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UITextField *moneyField;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation MinMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_moneyField becomeFirstResponder];
    
}


-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [_hud hide:YES];

}


- (IBAction)sureAction:(id)sender {
    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = YES;
    _hud.labelText = @"正在修改..";
    NSString *rangetype = [NSString stringWithFormat:@"%zd",_type+1];
    [AFHttpTool StoreUpdateDeliverys:Store_id
                           rangetype:rangetype
                               money:_moneyField.text
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
        
        
        [self.navigationController popViewControllerAnimated:YES];
        [_hud hide:YES];
        
    } failure:^(NSError *err) {
 
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    
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
