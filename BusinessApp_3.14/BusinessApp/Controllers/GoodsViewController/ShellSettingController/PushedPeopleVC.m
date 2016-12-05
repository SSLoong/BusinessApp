//
//  PushedPeopleVC.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/12/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PushedPeopleVC.h"
#import "PushChooseModel.h"
#import "PushChooseCell.h"

@interface PushedPeopleVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic, copy) UITableView *tableView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中


@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation PushedPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已推送的人";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _modelArray = [NSMutableArray array];
    _page = 1;

    [self createTabelView];
    // Do any additional setup after loading the view.
}



- (void)createTabelView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"PushChooseCell" bundle:nil]forCellReuseIdentifier:@"PushChooseCellID"];
    
    _tableView.mj_header = ({
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


- (void)loadData{
    
    [AFHttpTool GoodsPushChoose:Store_id store_goods_id:_store_goods_id activity_id:_activity_id page:_page progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }

        
        
        if(_page ==1 && self.modelArray.count>0){
            
            [self.modelArray removeAllObjects];
        }
        
        if (_tableView.mj_footer.hidden) {
            _tableView.mj_footer.hidden = NO;
        }
        
        for (NSDictionary * dic in response[@"data"][@"list"]) {
            PushChooseModel *model = [[PushChooseModel alloc]init];
            [model mj_setKeyValues:dic];
            [self.modelArray addObject:model];
        }
        
        _isLoading = NO;

        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }

        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [_tableView.mj_footer endRefreshing];
            
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
        if (_isLoading) {
            _isLoading = NO;
        }
        
        if (_tableView.mj_footer.isRefreshing) {
            
            [_tableView.mj_footer endRefreshing];
            
        }
        if (_tableView.mj_header.isRefreshing) {
            
            [_tableView.mj_header endRefreshing];
        }
    }];

    
    
}


#pragma mark -
#pragma mark -- tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"PushChooseCellID";
    
    PushChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PushChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = _modelArray[indexPath.row];
    [cell setChecked:NO];
    return cell;
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
