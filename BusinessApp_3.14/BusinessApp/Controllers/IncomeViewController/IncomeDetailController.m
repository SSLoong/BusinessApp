//
//  IncomeDetailController.m
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "IncomeDetailController.h"
#import "DateSiftViewController.h"
#import "RedListViewController.h"
#import "IncomeDetailModel.h"
#import "IncomeDetailCell.h"
#import "RedDetailstCell.h"
#import "PerfectDate.h"
#import "DateView.h"


@interface IncomeDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *detailArray;

@property (nonatomic,strong)UISegmentedControl *mySegmentCtrl;

@property(nonatomic,strong)UILabel *hejiLabel;

@property(nonatomic,strong)UILabel *moneyLabel;

@property(nonatomic,strong)PerfectDate *dateMenu;

@property(nonatomic,strong)DateView *dateView;

@property(nonatomic,assign)NSInteger page;//分页

@property(nonatomic,assign)BOOL isLoading;//是否在加载中


@end

@implementation IncomeDetailController


-(id)init{
    
    self = [super init];
    if (self) {
        
        _startTime = [AppUtil getStartTime];
        _endTime = [AppUtil getEndTime];
    }
    return self;
}

//懒加载数组
-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(NSMutableArray *)detailArray{
    
    if(_detailArray == nil){
        
        _detailArray = [NSMutableArray array];
        
    }
    return _detailArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(DetailScreenBtn:)];
    self.navigationItem.rightBarButtonItem=releaseButon;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSArray *array = @[@"全部",@"订单",@"进货",@"奖励"];
    
    _mySegmentCtrl = [[UISegmentedControl alloc] initWithItems:array];
    if (kDevice_Is_iPhone5) {
        //self.navigationItem.hidesBackButton = YES;
        _mySegmentCtrl.frame = CGRectMake((ScreenWidth-180)/2, 7, 180, 30);
    }else{
        _mySegmentCtrl.frame = CGRectMake((ScreenWidth-240)/2, 7, 240, 30);
    }

    
    [_mySegmentCtrl addTarget:self action:@selector(DetailSegmentCtrl:) forControlEvents:UIControlEventValueChanged];
    _mySegmentCtrl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _mySegmentCtrl;

    [self createHeaderView];
    [self createTableView];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"DataSiftNotification" object:nil];

}


- (void)DetailSegmentCtrl:(UISegmentedControl *)mySegmentCtrl{
        NSInteger num = mySegmentCtrl.selectedSegmentIndex;
        self.type = num;
    [self.tbView.mj_header beginRefreshing];
    
}

- (void)DetailScreenBtn:(UIButton *)btn{
    DateSiftViewController *vc = [[DateSiftViewController alloc]init];
    vc.sureBtnBlock = ^(NSString *startTime,NSString *endTime){
        self.startTime = startTime;
        self.endTime = endTime;
        [_tbView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];

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

    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44 ) style:UITableViewStyleGrouped];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[RedDetailstCell class] forCellReuseIdentifier:@"RedDetailstID"];
    
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    _tbView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [_tbView.mj_header beginRefreshing];
    
    _tbView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });

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

    __weak typeof(self) weakSelf = self;
    
    [AFHttpTool incomeDetailData:Store_id
                        start_time:_startTime
                        end_time:_endTime
                        page:_page
                        type:_type
                        progress:^(NSProgress *progress) {
                        
                        } success:^(id response) {
            if (!([response[@"code"]integerValue] == 0000)) {
                NSString *erroeMessage = response[@"msg"];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"错误:%@",erroeMessage];
                [_hud hide:YES afterDelay:3];
                return;
            }
            if (_page == 1 && self.dataArray.count >0) {
        
                [self.dataArray removeAllObjects];
                [self.tbView reloadData];

            }
    
            if (_tbView.mj_footer.hidden) {
            _tbView.mj_footer.hidden = NO;
            }
    
            for (NSDictionary *dic in response[@"data"]) {

            IncomeDetailModel *model = [[IncomeDetailModel alloc]init];
        
            [model mj_setKeyValues:dic];
        
            [weakSelf.dataArray addObject:model];
 
        }
            _isLoading = NO;
            if (_tbView.mj_header.isRefreshing) {
                [_tbView.mj_header endRefreshing];
            }
            if (self.dataArray.count == _page * 10) {
                [_tbView.mj_footer endRefreshing];
            }else{
                [_tbView.mj_footer endRefreshingWithNoMoreData];
            }
                            

            [self.tbView reloadData];
                            
        } failure:^(NSError *err) {
    
    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    _hud.labelText = @"Error";
    _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
    [_hud hide:YES afterDelay:3];
    if (_isLoading) {
        _isLoading = NO;
    }
    [_tbView.mj_header endRefreshing];
    [_tbView.mj_footer endRefreshing];
    
    
}];


}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [_hud hide:YES];
}



#pragma mark - tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"RedDetailstID";

    RedDetailstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell cofigIncomeModel:self.dataArray[indexPath.row]];
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
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
