//
//  OpenKicketViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OpenKicketViewController.h"
#import "OpenTicketViewCell.h"

@interface OpenKicketViewController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation OpenKicketViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开票服务";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[OpenTicketViewCell class] forCellReuseIdentifier:@"OpenTicketCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellId = @"OpenTicketCell";
    
    OpenTicketViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    
    if (self.index == indexPath.row) {
        
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
        [cell setSelected:YES];

    cell.nameLabel.text = @[@"不开发票",@"普通发票",@"增值税发票"] [indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    return cell;
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = @"正在修改..";
    
    [AFHttpTool changeReceipt:Store_id receipt:indexPath.row progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
     
        OpenTicketViewCell *cell = (OpenTicketViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES];

        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hud.labelText = @"修改成功";
        [_hud hide:YES afterDelay:2];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
    }];
    
    
    
    
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
