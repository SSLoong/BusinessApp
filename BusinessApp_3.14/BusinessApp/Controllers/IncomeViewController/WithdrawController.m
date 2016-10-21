//
//  WithdrawController.m
//  BusinessApp
//
//  Created by prefect on 16/3/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "WithdrawController.h"
#import "AddBankViewController.h"
#import "MyBankViewController.h"


@interface WithdrawController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,copy)NSString *moneyString;

@property(nonatomic,copy)NSString *bank_id;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@property (weak, nonatomic) IBOutlet UITextField *moneyField;


@property (weak, nonatomic) IBOutlet UILabel *cardLabel;


@property (weak, nonatomic) IBOutlet UILabel *bankLabel;



@end

@implementation WithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleString;
    
    [self loadData];

}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
    
}


-(void)loadData{

    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
    [AFHttpTool incomeDetail:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }

        NSDictionary *dataDic = response[@"data"];
        
        switch ([self.type integerValue]) {
                case 1:
                
                _moneyLabel.text = [NSString stringWithFormat:@"¥ %@",dataDic[@"goods_income"]];
                _moneyField.text =[NSString stringWithFormat:@"%@",dataDic[@"goods_income"]];
                break;
                case 2:
                
                _moneyLabel.text = [NSString stringWithFormat:@"¥ %@",dataDic[@"subsidy_income"]];
                _moneyField.text =[NSString stringWithFormat:@"%@",dataDic[@"subsidy_income"]];
                break;
                case 3:
                
                _moneyLabel.text = [NSString stringWithFormat:@"¥ %@",dataDic[@"award_income"]];
                _moneyField.text =[NSString stringWithFormat:@"%@",dataDic[@"award_income"]];
                break;
            default:
                break;
        }
        

        [self getDefaultBank];
    
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];

}


-(void)getDefaultBank{

    [AFHttpTool getDefaultBank:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        NSDictionary *dataDic = response[@"data"];
        
        NSLog(@"%@",response);

        if (dataDic.count == 0) {
    
        _bankLabel.text = @"";
            
        _cardLabel.text = @"请先添加银行卡";
        
        }else{
        
            _bankLabel.text = dataDic[@"open_branch"];
            _cardLabel.text = [NSString stringWithFormat:@"储蓄卡 尾号%@",dataDic[@"bank_card"]];
            self.bank_id = dataDic[@"id"];
        }

        [_hud hide:YES];
        
        [self.tableView reloadData];
        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 5;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section==1) {
        
        if (![_bankLabel.text isEqualToString:@"银行"]) {
            
            
            if ([_cardLabel.text isEqualToString:@"请先添加银行卡"]) {
                
            
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddBank" bundle:nil];
                
                AddBankViewController *vc = [storyboard  instantiateViewControllerWithIdentifier:@"AddBank"];
                
                __weak typeof(self) weakSelf = self;
                
                vc.addSuccess = ^(){
                    
                    _hud = [AppUtil createHUD];
                    
                    _hud.userInteractionEnabled = YES;
                    
                    [weakSelf getDefaultBank];
                    
                };
                
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else{
            
                MyBankViewController *vc = [[MyBankViewController alloc]init];
                
                vc.chooseBank = @"chooseBank";
                
                vc.bankString = ^(NSString *name,NSString *card,NSString *bank_id){
                
                    weakSelf.bank_id = bank_id;
                    
                    _bankLabel.text = name;
                    
                    _cardLabel.text = [NSString stringWithFormat:@"储蓄卡 尾号%@",card];

                };
                
                [self.navigationController pushViewController:vc animated:YES];
            
            }
        }

    }else if(indexPath.section ==2){
    
        _hud = [AppUtil createHUD];
        
        _hud.labelText = @"提现中...";
        
        _hud.userInteractionEnabled = NO;
        
        if (![self check]) {
            return;
        }
        
        
        [AFHttpTool withdrawalsApply:Store_id login_phone:LoginPhone type:self.type mount:_moneyField.text bank_id:self.bank_id progress:^(NSProgress *progress) {
            
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
                        [weakSelf.navigationController popViewControllerAnimated:YES];
  
                    } failure:^(NSError *err) {
                        
                        _hud.mode = MBProgressHUDModeCustomView;
                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                        _hud.labelText = @"Error";
                        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                        [_hud hide:YES afterDelay:3];
                        
                    }];
    
    }

}


-(BOOL)check{
    
    if (self.bank_id.length == 0) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        
        _hud.labelText = @"请先添加银行卡";
        
        [_hud hide:YES afterDelay:3];
        
        return NO;
    }
    
    return YES;
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
