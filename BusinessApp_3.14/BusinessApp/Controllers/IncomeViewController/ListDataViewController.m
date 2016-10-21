//
//  ListDataViewController.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/9/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ListDataViewController.h"
#import "RedDetailstCell.h"
#import "RewardListModel.h"
@interface ListDataViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isLoading;
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSMutableArray *dataArr;



@end

@implementation ListDataViewController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.type isEqualToString:@"1"]) {
        self.title = @"红包明细";
    }else{
        self.title = @"代金券明细";
    }
    _isFirst = YES;
    [self createHeaderView];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)createHeaderView{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    NSArray *array = [NSArray arrayWithObjects:@"日期",@"金额",@"备注", nil];
    for (int i = 0; i < 3 ; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 + ScreenWidth/3 *i, 0, ScreenWidth/3, 50)];
        label.text = array[i];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:label];
    }
}

-(void)createTableView{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, [AppUtil getScreenWidth], self.view.bounds.size.height-108) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];
    
    [self.tableView registerClass:[RedDetailstCell class] forCellReuseIdentifier:@"RedDetailstCell"];
    
    _tableView .mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [_tableView.mj_header beginRefreshing];
    
    
    _tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });
    
}

- (void)refresh
{
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

- (void)loadData
{
    [AFHttpTool IncomeRewardDetailed:Store_id type:self.type page:_page progress:^(NSProgress *progress) {
    
    } success:^(id response) {
        if (!([response[@"code"]integerValue] == 0000)) {
            NSString *erroeMessage = response[@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@",erroeMessage];
            [_hud hide:YES afterDelay:3];
            return;
        }
        if (_page == 1 && self.dataArr.count > 0) {
            [self.dataArr removeAllObjects];
            [self.tableView reloadData];
        }
        
        if (self.tableView.mj_footer.hidden) {
            self.tableView.mj_footer.hidden = NO;
        }
        for (NSDictionary *dic in response[@"data"]) {
            RewardListModel *model = [[RewardListModel alloc]init];
            [model mj_setKeyValues:dic];
            [self.dataArr addObject:model];
        }
        _isLoading = NO;
        _isFirst = NO;
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if (self.dataArr.count ==  _page *10 ) {
            [_tableView.mj_footer endRefreshing];
        }else{
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
        _isLoading = NO;
        
        _isFirst = NO;
        
        [_tableView reloadData];
        
        if (_tableView.mj_footer.isRefreshing) {
            
            [_tableView.mj_footer endRefreshing];
            
        }
        if (_tableView.mj_header.isRefreshing) {
            
            [_tableView.mj_header endRefreshing];
        }
    }];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"RedDetailstCell";
    
    RedDetailstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell configWithModel: self.dataArr[indexPath.row] type:self.type];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}

#pragma mark - Empty Data Source



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
    
    NSString *text = @"没有记录";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
