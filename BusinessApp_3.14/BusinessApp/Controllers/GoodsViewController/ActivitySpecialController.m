//
//  ActivitySpecialController.m
//  BusinessApp
//
//  Created by AlexChang on 16/9/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ActivitySpecialController.h"
#import "ActivityModel.h"
#import "ActivityCell.h"
#import "SpecialDetailViewController.h"

@interface ActivitySpecialController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UILabel *numLabel;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)BOOL isLoading;//是否加载中
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, strong)MJRefreshAutoNormalFooter  *refreshFooter;//MJ上拉刷新控件
@end

@implementation ActivitySpecialController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _isFirst = YES;
    [self createListView];
}

- (void)createListView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden = YES;
    _tableView = tableView;
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
    [AFHttpTool goodsSaleSpecial:Store_id page:_page progress:nil success:^(id response) {
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
        
        
        
        for (NSDictionary *dic in response[@"data"][@"list"]) {
            ActivityModel *model = [[ActivityModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
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
        _numLabel.text = [NSString stringWithFormat:@"%@",response[@"data"][@"totalCount"]];
        _tableView.hidden = NO;
        [_tableView reloadData];
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
    otherLabel.text = @"个活动专场";
    [bgView addSubview:otherLabel];
    
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"历史活动" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(lishiAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    
    
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
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(90, 20));
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.right.mas_equalTo(-10);
        
    }];
    btn.layer.cornerRadius = 10;
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellId = @"cellID";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
     cell.model = _dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *model = _dataArr[indexPath.row];
    SpecialDetailViewController *vc = [[SpecialDetailViewController alloc]init];
    vc.model = model;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lishiAction{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"尚未开通此功能" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alertView show];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
