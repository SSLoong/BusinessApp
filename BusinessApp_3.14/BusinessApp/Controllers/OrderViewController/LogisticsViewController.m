//
//  LogisticsViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "LogisticsViewController.h"
#import "OpenTicketViewCell.h"
#import "LogisticsModel.h"

@interface LogisticsViewController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LogisticsViewController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"选择配送";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickedDone:)];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[OpenTicketViewCell class] forCellReuseIdentifier:@"LogisticsCell"];
    
    [self loadData];
}


-(void) clickedDone:(id) sender
{

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (!indexPath) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请选择配送方式!" message:nil    delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    
    LogisticsModel *model = self.dataArray[indexPath.row];
    

    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = @"请稍等...";
    
    [AFHttpTool orderLogistics:_order_id ordexpress_company_ider_id:model.express_company_id progress:^(NSProgress *progress) {
        
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



-(void)loadData{

    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = YES;
    [AFHttpTool logisticsCompany:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        NSArray *dataArr = response[@"data"];
        
        for (NSDictionary *dic in dataArr) {
            
            LogisticsModel *model = [[LogisticsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
        
            [self.dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"LogisticsCell";
    
    OpenTicketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    LogisticsModel *model = self.dataArray[indexPath.row];
    
    [cell configModel:model];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    OpenTicketViewCell *cell = (OpenTicketViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
        
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OpenTicketViewCell *cell = (OpenTicketViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
}


@end
