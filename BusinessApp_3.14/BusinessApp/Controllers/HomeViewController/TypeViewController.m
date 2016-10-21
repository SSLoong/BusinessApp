//
//  TypeViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/4.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "TypeViewController.h"
#import "StoresTableViewController.h"


@interface TypeViewController ()

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)MBProgressHUD *hud;


@end

@implementation TypeViewController


//懒加载数组
-(NSArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSArray arrayWithObjects:@"连锁",@"自营",nil];

    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商户类型";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:footView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
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

    if(indexPath.row == 0){
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
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


        if (indexPath.row == 0) {
            
            StoresTableViewController *vc = [[StoresTableViewController alloc]init];
            
            vc.city_code = self.cityCode;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
        
            if (self.chooseType) {
                self.chooseType(cell.textLabel.text);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [_hud hide:YES];
    
}


@end
