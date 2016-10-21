//
//  OrderPriceController.m
//  BusinessApp
//
//  Created by prefect on 16/3/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderPriceController.h"

@interface OrderPriceController ()


@property (weak, nonatomic) IBOutlet UILabel *oldLabel;

@property (weak, nonatomic) IBOutlet UITextField *newsField;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation OrderPriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _oldLabel.text = [NSString stringWithFormat:@"原实付价格%@",self.oldPrice];
    _newsField.text = [self.oldPrice substringFromIndex:1];
    [_newsField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sureAction:(id)sender {
    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = @"请稍等...";
    
    [AFHttpTool orderUpdatePrice:Store_id order_id:self.order_id login_phone:LoginPhone                    money:_newsField.text progress:^(NSProgress *progress) {
        
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
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
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
