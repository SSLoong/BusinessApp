//
//  OrderDataController.m
//  BusinessApp
//
//  Created by prefect on 16/3/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderDataController.h"
#import "OrderModel.h"
#import "OrderViewCell.h"
#import <DateTools.h>
#import "OrderDetailViewController.h"
#import "PerfectDate.h"
#import "DateView.h"

@interface OrderDataController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,assign)BOOL isLoading;

@property(nonatomic,assign)NSInteger curPage;

@property(nonatomic,assign)NSInteger totalPage;

@property(nonatomic,copy)NSString *start_time;

@property(nonatomic,copy)NSString *end_time;

@property(nonatomic,copy)NSString *phone;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)PerfectDate *dateMenu;

@property(nonatomic,strong)DateView *dateView;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation OrderDataController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _start_time = [AppUtil getStartTime];
    
    _end_time = [AppUtil getEndTime];
    
    _curPage = 1;
    
    _phone = @"";
    
    [self createBtn];
    
    [self createTableView];
    
}





-(void)createBtn{


    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _dateView = [[DateView alloc]initWithFrame:CGRectMake(10, 2, 180, 42)];
    [_dateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateAction)]];
    [bgView addSubview:_dateView];

    
    _dateMenu = [[PerfectDate alloc]initWithOrigin:CGPointMake(0, 44) andHeight:165];
    
    
    __weak typeof(self) weakSelf = self;
    
    _dateMenu.didSelectBtn = ^(NSString *startTime,NSString *endTime){
        
        
    weakSelf.dateView.sYearLabel.text = [NSString stringWithFormat:@"%@年",[startTime substringToIndex:4]];
        
    weakSelf.dateView.eYearLabel.text = [NSString stringWithFormat:@"%@年",[endTime substringToIndex:4]];
        
    NSRange range = NSMakeRange(5, 2);
        
    NSString *s1 = [startTime substringWithRange:range];
        
    NSString *s2 = [startTime substringFromIndex:8];
    
    weakSelf.dateView.sDateLabel.text = [NSString stringWithFormat:@"%@月%@日",s1,s2];
        
        
    NSString *e1 = [endTime substringWithRange:range];
        
    NSString *e2 = [endTime substringFromIndex:8];
        
    weakSelf.dateView.eDateLabel.text = [NSString stringWithFormat:@"%@月%@日",e1,e2];
        
    weakSelf.start_time = startTime;
        
    weakSelf.end_time = endTime;
        
    [weakSelf.tableView.mj_header beginRefreshing];
        
    [weakSelf.dateMenu hideView];
        
    };
    
    [self.view addSubview:_dateMenu];


}


-(void)createTableView{


    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, [AppUtil getScreenWidth], self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];

    [self.tableView registerClass:[OrderViewCell class] forCellReuseIdentifier:@"OrderViewCell"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}



-(void)loadData{
    

    if (_isLoading) {
        

        
        return;
    }
    
    _isLoading = YES;
    
    _curPage = 1;
    

    
    [self manageData];
}


-(void)loadMoreData{
    
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    
    _curPage ++;
    
    [self manageData];
    
}


-(void)manageData{

    
    [AFHttpTool getOrder:Store_id start_time:_start_time end_time:_end_time type:_type phone:_phone page:_curPage progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud = [AppUtil createHUD];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        
        if (_curPage == 1 && _dataArray.count > 0) {
            
            [self.dataArray removeAllObjects];
        }
        
        
        if (self.tableView.mj_footer.hidden) {
            self.tableView.mj_footer.hidden = NO;
        }
        
        
        
        NSArray *dataArr =response[@"data"][@"list"];
        
        for (NSDictionary *dic in dataArr) {
            
            OrderModel *model = [[OrderModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
        }
        
        
        if (self.tableView.mj_header.isRefreshing) {
            
                [self.tableView.mj_header endRefreshing];
        }
        

        
        if (_curPage == [response[@"data"][@"totalPage"] integerValue]) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else if(0 == [response[@"data"][@"totalPage"] integerValue]){
            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_footer endRefreshing];
            
        }else{
            
            [self.tableView.mj_footer endRefreshing];
        }
        _isLoading = NO;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *err) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        _hud = [AppUtil createHUD];
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

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
 
    if (_isLoading) {
        return nil;
    }
    
    return [UIImage imageNamed:@"empty_placeholder"];
}



- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (_isLoading) {
        return nil;
    }
    
    NSString *text = @"没有订单哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"OrderViewCell";
    
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OrderModel *model = self.dataArray[indexPath.section];
    
    [cell configWithModel:model type:_type];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    return 5;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OrderDetailViewController *ctrl = [OrderDetailViewController new];
    
    ctrl.hidesBottomBarWhenPushed = YES;
    
    OrderModel *model = self.dataArray[indexPath.section];
    
    ctrl.order_id = [NSString stringWithFormat:@"%@",model.sId];
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
    
}


-(void)dateAction{
    
    [_dateMenu clickBtn];
    
}


@end
