//
//  ManagerController.m
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ManagerController.h"
#import "OpreationViewCell.h"
#import "MangerModel.h"
#import "AddManagerViewController.h"
@interface ManagerController ()

@property(nonatomic,copy)NSMutableArray * dataArray;

@property(nonatomic,assign)BOOL isloading;

@property(nonatomic,strong)MBProgressHUD *hud;


@end

@implementation ManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"操作员";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonClick)];
    [self.tableView registerClass:[OpreationViewCell class] forCellReuseIdentifier:@"OpreationViewCell"];
    

    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    
    [self loadData];

}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}
-(void)loadData{
    
    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool StoreOperatorList:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        
        if (!([response[@"code"]integerValue] == 0000) ){
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
        }
        NSArray * dicArray = response[@"data"];
        
        for (NSDictionary * dic in dicArray) {
            MangerModel * model = [[MangerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
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

-(void)buttonClick{
    
    AddManagerViewController * add = [[AddManagerViewController alloc]init];
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"OpreationViewCell";
    
    OpreationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.oneSwitch.tag = indexPath.row;
    
    [cell.oneSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    MangerModel *model = self.dataArray[indexPath.row];
    
    [cell configModel:model];
    
    return cell;
}


-(void)switchAction:(UISwitch *)sw{

    
     MangerModel *model = self.dataArray[sw.tag];
    
    _hud = [AppUtil createHUD];
    
    _hud.labelText = @"修改中";
    
    [AFHttpTool StoreLockoperator:Store_id
                      login_phone:LoginPhone
                            phone:model.login_phone
                           status:sw.on ? @"1":@"0" progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            if (sw.on) {
                
                sw.on = NO;
            }else{
                sw.on = YES;
            }
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        [_hud hide:YES];
        
    } failure:^(NSError *err) {
        
        if (sw.on) {
            
            sw.on = NO;
        }else{
            sw.on = YES;
        }
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];

    
    

}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MangerModel *model = self.dataArray[indexPath.row];
        
        NSString *phone = [NSString stringWithFormat:@"%@",model.login_phone];
        
        _hud = [AppUtil createHUD];
        
        _hud.userInteractionEnabled = NO;
        
        _hud.labelText = @"删除中...";
        
        [AFHttpTool StoreOperatorDel:Store_id login_phone:LoginPhone phone:phone
                            progress:^(NSProgress *progress) {
                                
                            } success:^(id response) {
                                
                                if (!([response[@"code"]integerValue] == 0000) ){
                                    
                                    NSString *errorMessage = response [@"msg"];
                                    _hud.mode = MBProgressHUDModeCustomView;
                                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                    _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                                    [_hud hide:YES afterDelay:3];
                                    
                                }
                                [self.dataArray removeObjectAtIndex:indexPath.row];
                                
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
    
}

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
