//
//  IncomeViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeDetailController.h"
#import "MyBankViewController.h"
#import "WithdrawController.h"
#import "IncomeGoodsController.h"
#import "InventoryListController.h"
#import "ListDataViewController.h"
#import <AFNetworking.h>
#import "SecurityUtil.h"

#import "RedListViewController.h"

NSString * const kGoods_income = @"goods_income";//在线
NSString * const kConfirm_income = @"confirm_income";//提现
NSString * const kCoupon_income = @"coupon_income";//代金券
NSString * const kRed_income = @"red_income";//红包

//NSString * const kSubsidy_income = @"subsidy_income";//补贴
//NSString * const kAward_income= @"award_income";//奖励
@interface IncomeViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic,assign)BOOL isHave;

@property (strong, nonatomic) IBOutlet UIButton *withdrawBtn;
//在线收入
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
//已提现金额
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
//红包
@property (strong, nonatomic) IBOutlet UILabel *redAwardLabel;
//代金券
@property (strong, nonatomic) IBOutlet UILabel *couponLabel;


//商品补贴
@property (weak, nonatomic) IBOutlet UILabel *subsidyLabel;
//活动奖励
@property (weak, nonatomic) IBOutlet UILabel *awardLabel;


@end

@implementation IncomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createWithdrawBtn];
    if ([DEFAULTS objectForKey:kGoods_income]) {
        
        [self upData];
        
    }
}

- (void)createWithdrawBtn{
    self.withdrawBtn.layer.borderWidth = 1;
    self.withdrawBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.withdrawBtn.layer.cornerRadius = 5;
    [self.withdrawBtn addTarget:self action:@selector(withdrawBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loadData{
    
    
    [AFHttpTool incomeDetail:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            _hud = [AppUtil createHUD];
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:2];
            
            return;
        }
        
        NSMutableDictionary *dataDic = response[@"data"];
        
        [DEFAULTS setObject:[NSString stringWithFormat:@"¥ %@",dataDic[@"goods_income"]] forKey:kGoods_income];
        //[DEFAULTS setObject:[NSString stringWithFormat:@"¥ %@",dataDic[@"subsidy_income"]] forKey:kSubsidy_income];
        //[DEFAULTS setObject:[NSString stringWithFormat:@"¥ %@",dataDic[@"award_income"]] forKey:kAward_income];
        [DEFAULTS setObject:[NSString stringWithFormat:@"¥ %@",dataDic[@"withdraw_confirm"]] forKey:kConfirm_income];
        [DEFAULTS setObject:[NSString stringWithFormat:@"¥ %@",dataDic[@"coupon_income"]] forKey:kCoupon_income];
        [DEFAULTS setObject:[NSString stringWithFormat:@"¥ %@",dataDic[@"red_income"]] forKey:kRed_income];

        [DEFAULTS synchronize];
        [self upData];
        
    } failure:^(NSError *err) {
        
        _hud = [AppUtil createHUD];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];
    
    
    
    
}


-(void)upData{
    
    _goodsLabel.text = [DEFAULTS objectForKey:kGoods_income];
    
    _redAwardLabel.text = [DEFAULTS objectForKey:kRed_income];
    
    _couponLabel.text = [DEFAULTS objectForKey:kCoupon_income];
    
    _confirmLabel.text = [DEFAULTS objectForKey:kConfirm_income];
    
    //_subsidyLabel.text = [DEFAULTS objectForKey:kSubsidy_income];
    
    //_awardLabel.text = [DEFAULTS objectForKey:kAward_income];
    
    [self.tableView reloadData];
    
}


- (void)withdrawBtnEvent:(UIButton *)btn{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Withdraw" bundle:nil];
    
    WithdrawController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WithdrawVC"];
    
    vc.type = @"1";
    
    vc.titleString = @"收入提现";
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            IncomeDetailController *vc = [[IncomeDetailController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1){
            //商品统计
            IncomeGoodsController *vc = [[IncomeGoodsController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 2){
            //我的银行卡
            MyBankViewController *vc = [[MyBankViewController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if (indexPath.section == 0){
        if (indexPath.row == 2) {
            //体现明细
            InventoryListController *vc = [[InventoryListController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 0){
            ListDataViewController *vc = [[ListDataViewController alloc]init];
            vc.type = @"1";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            ListDataViewController *vc = [[ListDataViewController alloc]init];
            vc.type = @"2";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    }
    
}


@end
