//
//  GoodsDetailController.m
//  BusinessApp
//
//  Created by perfect on 16/3/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsDetailController.h"
#import "InventoryCell.h"
#import "GoodsDetailModel.h"

@interface GoodsDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)NSInteger page;//分页

@property(nonatomic,strong)UILabel *hejiLabel;//合计

@property(nonatomic,strong)UILabel *moneyLabel;//钱数

@property(nonatomic,strong)NSMutableArray *dataArray;//数据源数组

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,copy)NSString *goodsName;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation GoodsDetailController


-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"商品明细";

    [self createChooseBtn];
    
    [self createTableView];
    
}



-(void)createChooseBtn{
    
 
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView1];
    
    
    
    _moneyLabel = [UILabel new];
    _moneyLabel.textColor = [UIColor colorWithHex:0xFD5B44];
    _moneyLabel.font= [UIFont systemFontOfSize:18.f];
    _moneyLabel.text = @"¥ 0";
    [bgView1 addSubview:_moneyLabel];
    
    
    
    _hejiLabel = [UILabel new];
    _hejiLabel.textColor = [UIColor lightGrayColor];
    _hejiLabel.font= [UIFont systemFontOfSize:18.f];
    _hejiLabel.text = @"合计:";
    [bgView1 addSubview:_hejiLabel];
    
    
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(13);
        
        make.height.mas_equalTo(18);
        
        make.right.mas_equalTo(-10);
        
    }];
    
    [_hejiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(13);
        
        make.height.mas_equalTo(18);
        
        make.right.equalTo(_moneyLabel.mas_left).offset(-10.f);
        
    }];
    

}


-(void)createTableView{
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-108) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[InventoryCell class] forCellReuseIdentifier:@"InventoryCell"];
    
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

    
    [AFHttpTool incomeGoodsDetailed:self.goods_id
                           store_id:Store_id
                               page:_page progress:^(NSProgress *progress) {
        
        
    } success:^(id response) {
        
        NSLog(@"%@",response);
        
        if (_page == 1 && self.dataArray.count >0) {
            
            [self.dataArray removeAllObjects];
        }
        
        if (_tbView.mj_footer.hidden) {
            _tbView.mj_footer.hidden = NO;
        }
        
        
        for (NSDictionary *dic in response[@"data"][@"list"]) {
            
            GoodsDetailModel *model = [[GoodsDetailModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
            
        }
        
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [_tbView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            
            [_tbView.mj_footer endRefreshing];
        }
        [_tbView.mj_header endRefreshing];
        
        _isLoading = NO;
        
        
        [_tbView reloadData];
        
        _goodsName = response[@"data"][@"goodsname"];
        
        NSString *moneyString = [NSString stringWithFormat:@"¥ %@",response[@"data"][@"allsumprice"]];
        
        _moneyLabel.text = moneyString;
        
        
        
    } failure:^(NSError *err) {
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        _isLoading = NO;
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
    
    return 57;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"InventoryCell";
    
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodsDetailModel *model = self.dataArray[indexPath.row];
    
    [cell configModel:model];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return _goodsName.length>0 ? _goodsName:@"";

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
