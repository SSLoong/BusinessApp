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

@interface FansRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * data;//tableView数据源
@property (strong, nonatomic) NSArray * dic;//请求到的数据
@property (assign, nonatomic) NSInteger page;//分页参数

@property (nonatomic, copy) NSString *nameStr;
@end

@implementation FansRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(FansScreenBtn:)];
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.tableView registerNib: [UINib nibWithNibName:@"FansRcordCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
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
            self.dic = response[@"data"];
            [self addTheDic:self.dic];
        }else{
            [self.view showLoadingWithMessage:response[@"msg"] hideAfter:2.0];
        }
        
    } failure:^(NSError * error) {
        [self endRefresh];
        //[self.view showLoadingWithMessage:@"网络连接错误,请稍后重试" hideAfter:2.0];
//        WYBLog(@"%@",error.description);
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FansRcordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    cell.dic = self.data[indexPath.row];
    WS(weakSelf);
    cell.buttonBlcok = ^(){
        [weakSelf pushToEditier:indexPath];
    };
    cell.detailsBlcok = ^(){
        [weakSelf pushToDetails:indexPath];
    };
    return cell;
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
    
    EditorNameVC * vc = VCWithStoryboardNameAndVCIdentity(@"StoreInfo", @"EditorNameVC");
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
