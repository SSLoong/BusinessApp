//
//  BindBanksViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "BindBanksViewController.h"

@interface BindBanksViewController ()

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *codeArray;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation BindBanksViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行开户行";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:footView];
    
    
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

-(NSMutableArray *)codeArray{
    
    if(_codeArray == nil){
        
        _codeArray = [NSMutableArray array];
        
    }
    return _codeArray;
}



-(void)loadData{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool incomeBindBankList:@"bankList" progress:^(NSProgress *progress) {
        
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

        for (NSDictionary *dic in dicArray) {
            
            NSString *name = dic[@"name"];
            
            NSString *code = dic[@"bank_code"];
    
            [self.dataArray addObject:name];
            
            [self.codeArray addObject:code];
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




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_didSelectRows) {
        _didSelectRows(cell.textLabel.text,self.codeArray[indexPath.row]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
