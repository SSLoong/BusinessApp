//
//  MyBankViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "MyBankViewController.h"
#import "BankListModel.h"
#import "BankListTableViewCell.h"
#import "AddBankViewController.h"

@interface MyBankViewController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MyBankViewController


-(id)initWithStyle:(UITableViewStyle)style{

    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
    [self.tableView registerClass:[BankListTableViewCell class] forCellReuseIdentifier:@"BankListcell"];
        
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的银行卡";
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
}


//懒加载数组
-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}


-(void)loadData{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool incomeBankList:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        
        NSArray *dicArray = response[@"data"];
        
        [_hud hide:YES];
        
        for (NSDictionary *dic in dicArray) {
            
            BankListModel *model = [[BankListModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [_dataArray addObject:model];
            
        }

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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return self.dataArray.count;
    }else{
        
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {



    
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"BankListcell";
        
        BankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BankListModel *model = self.dataArray[indexPath.row];
        
        [cell configWithModel:model];
        
        __weak typeof(self) weakSelf = self;
        
        
        if([model.is_default integerValue]>0){
        
            cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除"
                                                 backgroundColor:[UIColor redColor]                                                             callback:^BOOL(MGSwipeTableCell *sender) {

                                                     _hud = [AppUtil createHUD];
                                                     
                                                     _hud.userInteractionEnabled = NO;
                                                     
                                                     [AFHttpTool incomeDeleteBank:Store_id bank_id:model.sId progress:^(NSProgress *progress) {
                                                         
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
                                                         
                                                         [weakSelf.dataArray removeAllObjects];
                                                         
                                                         [weakSelf loadData];
                                                         
                                                     } failure:^(NSError *err) {
                                                         
                                                         _hud.mode = MBProgressHUDModeCustomView;
                                                         _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                                         _hud.labelText = @"Error";
                                                         _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                                         [_hud hide:YES afterDelay:3];
                                                         
                                                     }];

        
                                                     return YES;
                                                 }]];

        }else{
        
            cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" backgroundColor:     [UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
                
                _hud = [AppUtil createHUD];
                
                _hud.userInteractionEnabled = NO;
                
                [AFHttpTool incomeDeleteBank:Store_id bank_id:model.sId progress:^(NSProgress *progress) {
                    
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
                    
                    [weakSelf.dataArray removeAllObjects];
                    
                    [weakSelf loadData];
                    
                } failure:^(NSError *err) {
                    
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    _hud.labelText = @"Error";
                    _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                    [_hud hide:YES afterDelay:3];
                    
                }];
                
                
                                                    return YES;
                                }],[MGSwipeButton buttonWithTitle:@"默认" backgroundColor:[UIColor lightGrayColor]callback:^BOOL(MGSwipeTableCell *sender) {
                                    
                                    
                                    _hud = [AppUtil createHUD];
                                    
                                    _hud.userInteractionEnabled = NO;
                                    
                                    [AFHttpTool incomeSetDefaultBank:Store_id bank_id:model.sId progress:^(NSProgress *progress) {
                                        
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
                                        
                                        [weakSelf.dataArray removeAllObjects];
                                        
                                        [weakSelf loadData];
                                        
                                        
                                    } failure:^(NSError *err) {
                                        
                                        _hud.mode = MBProgressHUDModeCustomView;
                                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                        _hud.labelText = @"Error";
                                        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                        [_hud hide:YES afterDelay:3];
                                        
                                    }];
                                
                                                    return YES;
                                                }]];

        }

        cell.rightSwipeSettings.transition = MGSwipeTransition3D;
        
        return cell;

    }else{
    
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);

        cell.textLabel.text = @"添加银行卡";
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        cell.imageView.image = [UIImage imageNamed:@"Income_Add"];

        return cell;
    
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        BankListModel *model = self.dataArray[indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddBank" bundle:nil];
        
        AddBankViewController *vc = [storyboard  instantiateViewControllerWithIdentifier:@"AddBank"];
        vc.modle = model;
        //[vc configBankListModel:model];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    if (indexPath.section == 1) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddBank" bundle:nil];
        
        AddBankViewController *vc = [storyboard  instantiateViewControllerWithIdentifier:@"AddBank"];
        
        __weak typeof(self) weakSelf = self;
        
        vc.addSuccess = ^(){
        
            [weakSelf.dataArray removeAllObjects];
            
            [weakSelf loadData];
            
        };
        
        [self.navigationController pushViewController:vc animated:YES];

    }else if(self.chooseBank.length !=0){
    
        
        BankListModel *model = self.dataArray[indexPath.row];
        
        if (self.bankString) {
            self.bankString(model.open_branch,model.bank_card,model.sId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}




@end
