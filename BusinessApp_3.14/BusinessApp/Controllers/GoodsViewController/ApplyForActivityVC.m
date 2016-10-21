//
//  ApplyForActivityVC.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/9/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ApplyForActivityVC.h"

@interface ApplyForActivityVC ()

@property (copy, nonatomic) UILabel *messageLabel;

@property (nonatomic ,strong) UITextField *moneyTextField;

@property (nonatomic, strong) UITextField *numTextField;

@property (nonatomic, strong) UIButton *affirmBtn;

@property(nonatomic,strong)MBProgressHUD *hud;


@end

@implementation ApplyForActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self creatUI];
    [self setLayout];
    // Do any additional setup after loading the view.
}

- (void)creatUI{

    _messageLabel = [UILabel new];
    _messageLabel.textColor = [UIColor lightGrayColor];
    _messageLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_messageLabel];

    _moneyTextField = [UITextField new];
    _moneyTextField.backgroundColor = [UIColor whiteColor];
    _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyTextField.font = [UIFont systemFontOfSize:14];
    if ([self.changeType isEqualToString:@"1"]) {
        _moneyTextField.text = [NSString stringWithFormat:@"售价：¥%@元",self.real_price];
        _moneyTextField.textColor = [UIColor redColor];;
        _moneyTextField.userInteractionEnabled = NO;
    }
    _moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _moneyTextField.textAlignment = NSTextAlignmentCenter;
    _moneyTextField.placeholder = @"请输入商品的售卖价格";
    [self.view addSubview:_moneyTextField];
    
    
    _numTextField = [UITextField new];
    _numTextField.backgroundColor = [UIColor whiteColor];
    _numTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numTextField.font = [UIFont systemFontOfSize:14];
    _numTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _numTextField.textAlignment = NSTextAlignmentCenter;
    _numTextField.placeholder = @"请输入售卖的商品数量";
    [self.view addSubview:_numTextField];
    
    _affirmBtn = [UIButton new];
    [_affirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_affirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_affirmBtn setBackgroundColor:[UIColor orangeColor]];
    _affirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _affirmBtn.layer.masksToBounds = YES;
    _affirmBtn.layer.cornerRadius = 10.0;
    [_affirmBtn addTarget:self action:@selector(affirmBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_affirmBtn];
}

- (void)setLayout{
    
    if ([self.type integerValue] == 1) {
        _messageLabel.hidden = YES;
        
        [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(74);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(50);
        }];
        
        [_numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.moneyTextField.mas_bottom).offset(0.3f);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(50);

                    }];
        
        [_affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numTextField.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(40);
        }];

    }else{
        NSString *str = [NSString stringWithFormat:@"根据您货源市场的采购数量，最多可售卖%@瓶",self.innum];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, 4)];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(18,str.length - 18)];
        _messageLabel.attributedText =str1;

        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.top.equalTo(self.view).offset(74);
            make.size.mas_equalTo(CGSizeMake(300, 20));
        }];
        
        [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_messageLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(50);
        }];
        
        [_numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_moneyTextField.mas_bottom).offset(0.3);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(50);
        }];
        
        [_affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numTextField.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(40);
        }];
    }
    
   
}


- (void)affirmBtnEvent:(UIButton *)btn{
    _hud = [AppUtil createHUD];
    
    _hud.labelText = @"申请中...";
    
    _hud.userInteractionEnabled = NO;
    
    NSString *price = [NSString new];
    
    if ([self.changeType isEqualToString:@"1"]) {
        price = @"";
    }else{
        if (_moneyTextField.text.length > 0) {
            price = _moneyTextField.text;
        }else{
            price = self.real_price;
        }
    }

    [AFHttpTool goodsSpecialAdd:Store_id
                     special_id:_special_id
                      dealer_id:_dealer_id
                      goods_id:_goods_id
                            nums:_numTextField.text
                             price:price
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
