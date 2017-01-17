//
//  FansRecordVC.m
//  BusinessApp
//
//  Created by wangyebin on 16/8/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansRecordVC.h"
#import "FansRcordCell.h"
#import "EditorNameVC.h"
#import "FansDetailsVC.h"
#import "FansScreenVC.h"
#import "FansInfoVC.h"

#import "FansRewardModel.h"

@interface FansRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * data;//tableView数据源
@property (strong, nonatomic) NSArray * dic;//请求到的数据
@property (assign, nonatomic) NSInteger page;//分页参数

@property (nonatomic, copy) NSString *nameStr;
@end

@implementation FansRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"客户管理";
    
//     self.navigationController.navigationBar.translucent = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *releaseButon = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(FansScreenBtn:)];
    self.navigationItem.rightBarButtonItem=releaseButon;
    self.nameStr = [[NSString alloc]init];
    [self initData];
    [self initUI];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark --自定义方法
//初始化UI
- (void)initUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"FansRcordCell" bundle:nil] forCellReuseIdentifier:@"FansRcordCellID"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadDataConnect];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf loadDataConnect];
        //WYBLog(@"asdf");
    }];
    
    
    
}

- (void)FansScreenBtn:(UIButton *)btn{
    FansScreenVC *vc = [[FansScreenVC alloc]init];
    vc.searchBtnBlock = ^(NSString *name){
        self.nameStr = name;
        [self loadDataConnect];
    };

    [self.navigationController pushViewController:vc animated:YES];
    
}


//初始化数据
- (void)initData
{
    self.data = [[NSMutableArray alloc]initWithCapacity:10];
    self.page = 1;
    
}


//网络连接
- (void)loadDataConnect
{
    self.view.userInteractionEnabled = NO;
    [AFHttpTool manageTheFan:Store_id page:[NSString stringWithFormat:@"%ld",(long)self.page]  name:_nameStr progress:^(NSProgress * progress){
        
    } success:^(id response) {
        WYBLog(@"%@",response);
        [self endRefresh];

        if ([response[@"code"] isEqualToString:@"0000"]) {
            
            if (_page == 1 && self.data.count >0) {
                
                [self.data removeAllObjects];
                [self.tableView reloadData];
                
            }

            
            for (NSDictionary *dic in response[@"data"]) {
                FansRewardModel *model = [[FansRewardModel alloc]init];
                [model mj_setKeyValues:dic];
                [self.data addObject:model];
            }
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (self.data.count == _page * 10) {
                [_tableView.mj_footer endRefreshing];
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
            
        }else{
            [self.view showLoadingWithMessage:response[@"msg"] hideAfter:2.0];
        }
        
    } failure:^(NSError * error) {
        [self endRefresh];

        
        
    }];
    
}


//往数据源中添加数据
- (void)addTheDic:(NSArray *)object
{

    NSArray * arr = object;
    
    if (arr.count == 0) {
        return;
    }
    
    if (self.page == 1) {
        [self.data removeAllObjects];
    }
    [self.data addObjectsFromArray:arr];
    
    if (self.data.count == _page * 10) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.tableView reloadData];
    
    
}

//结束刷新
- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.view.userInteractionEnabled = YES;
}


#pragma mark --数据源和代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //FansRcordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
     static NSString *cellID = @"FansRcordCellID";
    FansRcordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"FansRcordCell" bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    FansRewardModel *model = self.data[indexPath.row];
    [cell configDataModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FansRewardModel *model = self.data[indexPath.row];
    FansInfoVC *vc = [[FansInfoVC alloc]init];
    vc.fans_id = model.id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)pushToDetails:(NSIndexPath *)path
{
    NSDictionary * dic = self.data[path.row];
    
    FansDetailsVC * vc = VCWithStoryboardNameAndVCIdentity(@"StoreInfo", @"FansDetailsVC");
    vc.hidesBottomBarWhenPushed = YES;
    vc.dicData = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)pushToEditier:(NSIndexPath *)path
{
    NSDictionary * dic = self.data[path.row];
    
    EditorNameVC * vc = VCWithStoryboardNameAndVCIdentity(@"StoreIn fo", @"EditorNameVC");
    vc.hidesBottomBarWhenPushed = YES;
    vc.customerID = dic[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
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
