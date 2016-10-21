//
//  SaleNumViewController.m
//  BusinessApp
//
//  Created by prefect on 16/4/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SaleNumViewController.h"

@interface SaleNumViewController ()


@property (weak, nonatomic) IBOutlet UITextField *numFiled;

@property(nonatomic,strong)MBProgressHUD *hud;


@end

@implementation SaleNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sureAction:(id)sender {
    
    _hud = [AppUtil createHUD];
    
    _hud.labelText = @"申请中...";
    
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool goodsSpecialAdd:Store_id special_id:_special_id dealer_id:_dealer_id goods_id:_goods_id nums:_numFiled.text price: nil progress:^(NSProgress *progress) {

        
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
