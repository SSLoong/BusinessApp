//
//  SalesAwardViewController.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SalesAwardViewController.h"
#import "GoodsAwardCell.h"
#import "SalesAwardModel.h"
@interface SalesAwardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UILabel *numLabel;
@property (nonatomic, strong)UILabel *moneyLabel;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)BOOL isLoading;//是否加载中
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, strong)MJRefreshAutoNormalFooter  *refreshFooter;//MJ上拉刷新控件

@end

@implementation SalesAwardViewController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createListView];
    // Do any additional setup after loading the view.
}

- (void)createListView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableHeaderView = [self createTopViews];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
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

- (UIView *)createTopViews
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [view addSubview:bgView];
    
    UIImageView *saleImage = [UIImageView new];
    saleImage.image = [UIImage imageNamed:@"Goods_sale"];
    saleImage.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:saleImage];
    
    
    UILabel *nowLabel = [UILabel new];
    nowLabel.textColor = [UIColor grayColor];
    nowLabel.font = [UIFont systemFontOfSize:14];
    nowLabel.text = @"当前有";
    [bgView addSubview:nowLabel];
    
    _numLabel = [UILabel new];
    _numLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.text = @"0";
    [bgView addSubview:_numLabel];
    
    UILabel *otherLabel = [UILabel new];
    otherLabel.textColor = [UIColor grayColor];
    otherLabel.font = [UIFont systemFontOfSize:14];
    otherLabel.text = @"个货源商品";
    [bgView addSubview:otherLabel];

    _moneyLabel = [UILabel new];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    _moneyLabel.text = @"0元";
    [bgView addSubview:_moneyLabel];
    
    UILabel *awardLabel = [UILabel new];
    awardLabel.textColor = [UIColor grayColor];
    awardLabel.font = [UIFont systemFontOfSize:14];
    awardLabel.text = @"可获取奖励";
    [bgView addSubview:awardLabel];
    


    
    [saleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.left.mas_equalTo(10);
        
        make.size.mas_equalTo(CGSizeMake(16, 16));
        
    }];
    
    
    [nowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.left.equalTo(saleImage.mas_right).offset(5.f);
        
        make.height.mas_equalTo(14);
        
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.left.equalTo(nowLabel.mas_right);
        
        make.height.mas_equalTo(14);
        
    }];
    
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.left.equalTo(_numLabel.mas_right);
        
        make.height.mas_equalTo(14);
        
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.right.mas_equalTo(-10);
        
        make.height.mas_equalTo(14);

    }];
    
    [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.height.mas_equalTo(14);
        make.right.equalTo(_moneyLabel.mas_left).offset(0);

    }];
    
    
    return view;
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
        [AFHttpTool goodsSaleStatistics:Store_id page:_page progress:nil success:^(id response) {
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
            }
            
            if (self.tableView.mj_footer.hidden) {
                self.tableView.mj_footer.hidden = NO;
            }
            
            
            _numLabel.text = [NSString stringWithFormat:@"%@",response[@"data"][@"goodsnums"]];
            NSString *moneyStr = [NSString stringWithFormat:@"%0.2f元",[response[@"data"][@"rewardmoney"]floatValue]];

            
             _moneyLabel.text = moneyStr;
            

            for (NSDictionary *dic in response[@"data"][@"list"]) {
                SalesAwardModel *model = [[SalesAwardModel alloc]init];
                [model mj_setKeyValues:dic];
                [self.dataArr addObject:model];
            }
            _isLoading = NO;
            _isFirst = NO;
            if (self.dataArr.count > 0) {
                if (_tableView.mj_footer.hidden) {
                    _tableView.mj_footer.hidden = NO;
                }
            }else{
                if (!_tableView.mj_footer.hidden) {
                    _tableView.mj_footer.hidden = YES;
                }
            }
            if ([response[@"data"][@"totalPage"] integerValue] == 0 ||_page == [response[@"data"][@"totalPage"] integerValue]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            _tableView.hidden = NO;
            [_tableView reloadData];
 
        } failure:^(NSError *err) {
            
        }];
}

#pragma mark == TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellId = @"GoodsAwardCellID";
    GoodsAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[GoodsAwardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SalesAwardModel *model = self.dataArr[indexPath.row];
    [cell configSalesAwardModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
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
