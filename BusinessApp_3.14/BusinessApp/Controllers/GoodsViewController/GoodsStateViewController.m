//
//  GoodsStateViewController.m
//  BusinessApp
//
//  Created by perfect on 16/4/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsStateViewController.h"

@interface GoodsStateViewController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UISwitch * oneSwitch;

@end

@implementation GoodsStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销设置";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView * allView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    allView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:allView];
    
    UILabel * staLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, self.view.bounds.size.width,14)];
    staLabel.text = @"选择营销策略";
    staLabel.font = [UIFont systemFontOfSize:14];
    staLabel.textAlignment = NSTextAlignmentLeft;
    staLabel.textColor = [UIColor blackColor];
    [self.view addSubview:staLabel];
    
    UIButton * cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 98, 60, 30)];
    [cutBtn setTitle:@"√立减" forState:UIControlStateNormal];
    [cutBtn setTitleColor:[UIColor colorWithHex:0xFD5B44] forState:UIControlStateNormal];
    cutBtn.layer.cornerRadius = 3.0f;
    cutBtn.layer.masksToBounds = YES;
    cutBtn.layer.borderWidth = 0.5f;
    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cutBtn.layer setBorderColor:[[UIColor colorWithHex:0xFD5B44]CGColor]];
    [self.view addSubview:cutBtn];

   
    UIView * oneView = [[UIView alloc]initWithFrame:CGRectMake(10, 140, self.view.bounds.size.width, 1)];
    oneView.backgroundColor = [UIColor lightGrayColor];
    oneView.alpha = 0.5f;
    [self.view addSubview:oneView];
    
    UILabel * cutLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,150, self.view.bounds.size.width, 14)];
    cutLabel.text = @"立减金额";
    cutLabel.textColor = [UIColor blackColor];
    cutLabel.font = [UIFont systemFontOfSize:14];
    cutLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:cutLabel];
    
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 174, 14, 14)];
    moneyLabel.text = @"¥";
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:moneyLabel];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(24, 174, self.view.bounds.size.width-20, 30)];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textColor = [UIColor blackColor];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    if (_money!=0) {
        _textField.text = [NSString stringWithFormat:@"%ld",(long)_money];
    }

    _textField.placeholder = @"请输入立减金额";
    [self.view addSubview:_textField];
    
    UILabel * recommend = [[UILabel alloc]initWithFrame:CGRectMake(10, 220, 140, 14)];
    recommend.text = @"是否推荐到店铺主页";
    recommend.textColor = [UIColor blackColor];
    recommend.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:recommend];
    
    _oneSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-60, 210, self.view.bounds.size.width, 14)];

    _oneSwitch.on = [_recommend integerValue]>0 ? YES:NO;
    _oneSwitch.tintColor =  [UIColor whiteColor];
    _oneSwitch.onTintColor = [UIColor colorWithHex:0xFD5B44];

    [self.view addSubview:_oneSwitch];
    
    UIButton * enBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 250, self.view.bounds.size.width-20, 40)];
    [enBtn setTitle:@"确定" forState:UIControlStateNormal];
    [enBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    enBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [enBtn addTarget:self action:@selector(addSet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enBtn];
}

-(void)addSet:(UIButton *)btn{

    _hud = [AppUtil createHUD];
    
    _hud.labelText = @"设置中...";
    
    _hud.userInteractionEnabled = NO;
    
    _recommend = _oneSwitch.on ? @"1":@"0";

    [AFHttpTool GoodsSetSubamount:_store_goods_id subamount:_textField.text store_id:Store_id recommend:_recommend progress:^(NSProgress *progress) {
        
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
