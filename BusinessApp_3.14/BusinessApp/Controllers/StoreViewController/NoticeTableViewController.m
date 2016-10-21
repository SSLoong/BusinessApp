//
//  NoticeTableViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "NoticeTableViewController.h"
#import "NoticeViewCell.h"
#import "NoticeModel.h"
#import "InventoryListController.h"
#import "OrderDetailViewController.h"

@interface NoticeTableViewController ()

@property(nonatomic,copy)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray *listArray;

@property(nonatomic,assign)NSInteger page;//分页

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)BOOL isLoading;

@end

@implementation NoticeTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"通知中心";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[NoticeViewCell class] forCellReuseIdentifier:@"NoticeViewCell"];
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });
    
    
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}

-(void)refresh{
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page = 1;
    
    [self loadData];
    
}


-(void)loadMoreData{
    
    
    if (_isLoading) {
        
        return;
    }
    
    _isLoading = YES;
    
    _page++;
    
    [self loadData];
}



-(void)loadData{
    
    
    
    
    [AFHttpTool StoreMsgList:Store_id page:_page progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        
        if(_page ==1 && self.dataArray.count>0){
            
            [self.dataArray removeAllObjects];
        }
        
        if (self.tableView.mj_footer.hidden) {
            self.tableView.mj_footer.hidden = NO;
        }
        
        NSArray * dicArray = response[@"data"][@"list"];
        for (NSDictionary * dic in dicArray) {
            
            NoticeModel * model = [[NoticeModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            
            [_dataArray addObject:model];
        }
        
        _isLoading = NO;
        
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
        
        if (self.tableView.mj_header.isRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *err) {
        
        _isLoading = NO;
        
        if (self.tableView.mj_footer.isRefreshing) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        if (self.tableView.mj_header.isRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    static NSString * str = @"NoticeViewCell";
    
    NoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
    NoticeModel * model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除"
                                         backgroundColor:[UIColor redColor]                                                             callback:^BOOL(MGSwipeTableCell *sender) {
                                             
                                             _hud = [AppUtil createHUD];
                                             
                                             _hud.userInteractionEnabled = NO;
                                             
                                             [AFHttpTool StoreDeleteMsg:model.msg_id progress:^(NSProgress *progress) {
                                                 
                                             } success:^(id response) {
                                                 
                                                 if (!([response[@"code"]integerValue]==0000)) {
                                                     
                                                     NSString *errorMessage = response [@"msg"];
                                                     _hud.mode = MBProgressHUDModeCustomView;
                                                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                                     _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                                                     [_hud hide:YES afterDelay:3];
                                                     
                                                     return;
                                                 }
                                                 
                                                 
                                                 [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                                                 [weakSelf.tableView reloadData];
                                                 
                                                 [_hud hide:YES];
                                                 
                                                 
                                                 
                                             } failure:^(NSError *err) {
                                                 
                                                 _hud.mode = MBProgressHUDModeCustomView;
                                                 _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                                 _hud.labelText = @"Error";
                                                 _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                                                 [_hud hide:YES afterDelay:3];
                                                 
                                                 
                                                 
                                             }];
                                             
                                             
                                             return YES;
                                         }]];
    
    [cell configModel:model];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeModel * model = self.dataArray[indexPath.row];
    
    
    [AFHttpTool StoreReadMsg:model.msg_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        model.flag = @"1";
        
        [self.tableView reloadData];
        
    } failure:^(NSError *err) {
        
    }];
    
    
    if ([model.type integerValue] == 1) {
        
        InventoryListController *vc = [[InventoryListController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([model.type integerValue] == 2){
        
        OrderDetailViewController *vc= [[OrderDetailViewController alloc]init];
        
        vc.order_id = model.order_id;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}







@end
