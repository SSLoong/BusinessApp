//
//  InventoryListController.m
//  BusinessApp
//
//  Created by perfect on 16/3/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "InventoryListController.h"
#import "InventoryListCell.h"
#import "InventoryListModel.h"
#import "PerfectDate.h"
#import "DateView.h"
#import "WithdrawDetailCell.h"
#import "DateSiftViewController.h"


@interface InventoryListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSString * type;

@property(nonatomic,assign)NSInteger page;//分页

@property(nonatomic,strong)UILabel *hejiLabel;//合计

@property(nonatomic,strong)UILabel *moneyLabel;//钱数

@property(nonatomic,strong)NSMutableArray *dataArray;//数据源数组

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,copy)NSString *goodsName;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,strong)PerfectDate *dateMenu;

@property(nonatomic,strong)DateView *dateView;

@end

@implementation InventoryListController


-(id)init{
    
    
    self = [super init];
    
    if (self) {
        
        _startTime = [AppUtil getStartTime];
        
        _endTime = [AppUtil getEndTime];
        
        _page = 1;
        
        _type = @"";
    }
    return self;
}
-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(screenBtn:)];
    self.navigationItem.rightBarButtonItem=releaseButon;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"提现明细";
    [self createHeaderView];
    [self createTableView];

}

- (void)screenBtn:(UIButton *)btn{
    
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
    
    NSArray *array = [NSArray arrayWithObjects:@"日期",@"金额",@"状态",@"备注", nil];
    for (int i = 0; i < 4 ; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 + ScreenWidth/4 *i, 0, ScreenWidth/4, 50)];
        label.text = array[i];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:label];
    }
}



-(void)dateAction{
    
    [_dateMenu clickBtn];

    
}
    
    
-(void)createTableView{
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, self.view.bounds.size.width, self.view.bounds.size.height-108) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[WithdrawDetailCell class] forCellReuseIdentifier:@"WithdrawDetailCellID"];
    
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
    

    [AFHttpTool IncomeWithDrawalsDetailed:Store_id
                                     type:_type
                               start_time:_startTime
                                 end_time:_endTime
                                     page:_page
                                 progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if(_page ==1 && self.dataArray.count>0){
            
            [self.dataArray removeAllObjects];
        }
        
        if (_tbView.mj_footer.hidden) {
            _tbView.mj_footer.hidden = NO;
        }
        for (NSDictionary * dic in response[@"data"][@"list"]) {
            InventoryListModel * model = [[InventoryListModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }

        if (_isLoading) {
            _isLoading = NO;
        }
        
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [_tbView.mj_footer endRefreshingWithNoMoreData];
            
        }else{

            [_tbView.mj_footer endRefreshing];

        }
 

        if (_tbView.mj_header.isRefreshing) {
            
            [_tbView.mj_header endRefreshing];
        }
        
        NSString *moneyString = [NSString stringWithFormat:@"¥ %@",response[@"data"][@"sumamount"]];
        
        _moneyLabel.text = moneyString;
        
        [_tbView reloadData];
        
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

        if (_tbView.mj_footer.isRefreshing) {
            
            [_tbView.mj_footer endRefreshing];
            
        }
        if (_tbView.mj_header.isRefreshing) {
            
            [_tbView.mj_header endRefreshing];
        }

    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"WithdrawDetailCellID";
    
    WithdrawDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    InventoryListModel *model = self.dataArray[indexPath.row];
    
    [cell cofigModel:model];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;

}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
