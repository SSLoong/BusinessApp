//
//  FansInfoVC.m
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FansInfoVC.h"
#import "FansNameCell.h"
#import "FansConsumeCell.h"
#import "FansStoreCell.h"
#import "FansGoodsCell.h"
#import "EditorNameVC.h"
#import "ChooseTimeVC.h"


@interface FansInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign)BOOL isLoading;//是否加载中
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, assign) int type;


@end

@implementation FansInfoVC


-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(ScreenTimeBtn:)];
    self.navigationItem.rightBarButtonItem=releaseButon;

    
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)ScreenTimeBtn:(id)sender{
    
    ChooseTimeVC *vc = [[ChooseTimeVC alloc]init];
    vc.chooseTimeBlock = ^(int type){
        self.type = type;
        [self refresh];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"FansNameCell" bundle:nil]forCellReuseIdentifier:@"FansNameCellID"];
    [self.tableView registerNib: [UINib nibWithNibName:@"FansConsumeCell" bundle:nil]forCellReuseIdentifier:@"FansConsumeCellID"];
    [self.tableView registerNib: [UINib nibWithNibName:@"FansStoreCell" bundle:nil]forCellReuseIdentifier:@"FansStoreCellID"];
    [self.tableView registerNib: [UINib nibWithNibName:@"FansGoodsCell" bundle:nil]forCellReuseIdentifier:@"FansGoodsCellID"];
    
    
    
    [self.view addSubview:_tableView];
    
//    _tableView .mj_header = ({
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        header;
//    });
//    [_tableView.mj_header beginRefreshing];
//    
//    _tableView.mj_footer = ({
//        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        footer.refreshingTitleHidden = YES;
//        footer.hidden = YES;
//        footer;
//    });
//    
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

- (void)loadData{



}

#pragma mark -
#pragma mark -- TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 3;
    }else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 90;
    }else
        return 44;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }else
        return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //NSDictionary * dic = self.dataArr[indexPath.row];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if (indexPath.section == 0) {
        FansNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FansNameCellID"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"FansNameCell" bundle:nil] forCellReuseIdentifier:@"FansNameCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"FansNameCellID"];
        }
        cell.changeBtnBlock = ^(){
                EditorNameVC * vc = VCWithStoryboardNameAndVCIdentity(@"StoreInfo", @"EditorNameVC");
                vc.hidesBottomBarWhenPushed = YES;
                vc.customerID = dic[@"id"];
                [self.navigationController pushViewController:vc animated:YES];
        };
        [cell configDataDic:dic];
        return cell;
        
        
    }else if (indexPath.section == 1){
        FansConsumeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FansConsumeCellID"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"FansConsumeCell" bundle:nil] forCellReuseIdentifier:@"FansConsumeCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"FansConsumeCellID"];
        }
        [cell configDataDic:dic];
        return cell;

    }else if (indexPath.section == 2){
        FansStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FansStoreCellID"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"FansStoreCell" bundle:nil] forCellReuseIdentifier:@"FansStoreCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"FansStoreCellID"];
        }
        [cell configDataDic:dic];
        return cell;
    
    }else{
        FansGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansGoodsCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"FansGoodsCell" bundle:nil] forCellReuseIdentifier:@"FansGoodsCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"FansGoodsCellID"];
        }
        [cell configDataDic:dic];
        return cell;
    }
    
    
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