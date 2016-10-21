//
//  RevisedPriceVC.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "RevisedPriceVC.h"
#import "OrderCodeViewController.h"

@interface RevisedPriceVC ()<UITextFieldDelegate>
@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation RevisedPriceVC

-(NSMutableArray *)generals{
    if (_generals == nil) {
        _generals = [NSMutableArray array];
    }
    return _generals;
}



-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [_hud hide:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.MoneyTextField becomeFirstResponder];
    self.MoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.MoneyTextField.delegate = self;
    [self.MoneyTextField addTarget:self action:@selector(moneyTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.money.text = [NSString stringWithFormat:@"¥%@",self.moneyStr];
    [self createWithdrawBtn];
    // Do any additional setup after loading the view.
}

- (void)moneyTextChange:(UITextField *)textField{

    NSArray *arr = [textField.text componentsSeparatedByString:@"."];
    if (arr.count > 2) {
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请输入正确的格式" cancelButtonTitle:@"重新输入" otherButtonTitles:nil handler:nil];
        int numb = 1;
        self.MoneyTextField.text = [textField.text substringToIndex:textField.text.length-numb];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    
    [futureString  insertString:string atIndex:range.location];

    NSInteger flag=0;
    
    const NSInteger limited = 2;
    
    for (NSInteger i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                
                return NO;

            }
            break;
        }
        
        flag++;
        
    }
    return YES;
    
}

- (void)createWithdrawBtn{
    self.sure.layer.masksToBounds = YES;
    self.sure.layer.cornerRadius = 15;
    self.sure.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:65.0/255.0 blue:47.0/255.0 alpha:1.0f];
    [self.sure addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sureBtn:(UIButton *)btn{
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = YES;
    _hud.labelText = @"正在修改..";
    [AFHttpTool CartBargain:_key
                              store_id:Store_id
                           special_id:_special_id
                                  sg_id:_sg_id
                                   price:self.MoneyTextField.text
                             progress:^(NSProgress *progress) {

    } success:^(id response) {
        
        if (!([response[@"code"]integerValue] == 0000)) {
            NSString *erroeMessage = response[@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@",erroeMessage];
            [_hud hide:YES afterDelay:3];
            return;
        }
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hud.labelText = @"修改成功";
        [_hud hide:YES afterDelay:3];

        
        _lastMoney = [response[@"data"][@"total_amount"] integerValue];
        _subMoney = [response[@"data"][@"sub_amount"] integerValue];
        _generals = response[@"data"][@"generals"];
        _specials = response[@"data"][@"specials"];
        _key = response[@"data"][@"key"];

        
        if (_type == 1) {
            if (self.changeBtnBlockOne) {
                self.changeBtnBlockOne(self.generals,self.specials,self.lastMoney,self.subMoney,self.key,self.sg_id);
            }
        }else{
            if (self.changeBtnBlockTwo) {
                self.changeBtnBlockTwo(self.generals,self.specials,self.lastMoney,self.subMoney,self.key,self.sg_id);
            }
        }
            
        
     
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *err) {
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
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
