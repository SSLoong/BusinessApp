//
//  IncomeGoodsController.m
//  BusinessApp
//
//  Created by prefect on 16/3/16.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "IncomeGoodsController.h"
#import "IncomeGoodsModel.h"
#import "IncomeGoodsCell.h"
#import "PerfectMenu.h"
#import "PerfectDate.h"
#import "AllGoodsModel.h"
#import "DateView.h"
#import "GoodsDetailController.h"

@interface IncomeGoodsController ()<UITableViewDelegate,UITableViewDataSource,PerfectMenuDataSource,PerfectMenuDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *listArray;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,strong)PerfectMenu *menu;

@property(nonatomic,strong)PerfectDate *dateMenu;

@property(nonatomic,strong)DateView *dateView;

@property(nonatomic,strong)UIButton *rightBtn;//分类按钮

@property(nonatomic,strong)UILabel *hejiLabel;//合计

@property(nonatomic,strong)UILabel *moneyLabel;//钱数

@property(nonatomic,copy)NSString *startTime;//开始时间

@property(nonatomic,copy)NSString *endTime;//结束时间

@property(nonatomic,copy)NSString *brand_id;//酒品id

@property(nonatomic,assign)NSInteger page;//分页

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@end

@implementation IncomeGoodsController

-(id)init{


    self = [super init];
    
    if (self) {
        
    _brand_id = @"";
        
    _startTime = [AppUtil getStartTime];
        
    _endTime = [AppUtil getEndTime];
        
    _page = 1;
        
    }
    return self;
}

//懒加载数组
-(NSMutableArray *)listArray{
    
    if(_listArray == nil){
        
        _listArray = [NSMutableArray array];
        
    }
    return _listArray;
}


-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品统计";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self createChooseBtn];
    
    [self createTableView];
}

-(void)createChooseBtn{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 43)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    _dateView = [[DateView alloc]initWithFrame:CGRectMake(10, 0, 180, 43)];
    _dateView.backgroundColor = [UIColor clearColor];
    [_dateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateAction)]];
    [bgView addSubview:_dateView];
    
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
    

    
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60, 11, 50, 21)];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"selectd_image_un"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"selectd_image"] forState:UIControlStateHighlighted];
    _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 35, 7, 0);
    [_rightBtn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.hidden = YES;
    [bgView addSubview:_rightBtn];

    
    _menu = [[PerfectMenu alloc]initWithOrigin:CGPointMake(0, 108) andHeight:self.view.bounds.size.height-108-44];
    
    _menu.delegate = self;
    
    _menu.dataSource = self;
    
    _menu.transformView = _rightBtn.imageView;
    
    [self.view addSubview:_menu];
    
    _dateMenu = [[PerfectDate alloc]initWithOrigin:CGPointMake(0, 108) andHeight:165];
    
    
    __weak typeof(self) weakSelf = self;
    
    _dateMenu.didSelectBtn = ^(NSString *startTime,NSString *endTime){
    
        if (weakSelf.dataArray.count >0) {
 
                [weakSelf.dataArray removeAllObjects];
        }
        

        weakSelf.startTime = startTime;
        
         weakSelf.endTime= endTime;
        
        weakSelf.dateView.sYearLabel.text = [NSString stringWithFormat:@"%@年",[startTime substringToIndex:4]];
        
        weakSelf.dateView.eYearLabel.text = [NSString stringWithFormat:@"%@年",[endTime substringToIndex:4]];
        
        NSRange range = NSMakeRange(5, 2);
        
        NSString *s1 = [startTime substringWithRange:range];
        
        NSString *s2 = [startTime substringFromIndex:8];
        
        weakSelf.dateView.sDateLabel.text = [NSString stringWithFormat:@"%@月%@日",s1,s2];


        NSString *e1 = [endTime substringWithRange:range];
        
        NSString *e2 = [endTime substringFromIndex:8];
        
        weakSelf.dateView.eDateLabel.text = [NSString stringWithFormat:@"%@月%@日",e1,e2];
        
        
        [weakSelf.tbView.mj_header beginRefreshing];
        
        [weakSelf.dateMenu hideView];
        
    };
    
    [self.view addSubview:_dateMenu];
    
}


-(void)dateAction{

    [_dateMenu clickBtn];
    [_menu hideView];

}

-(void)btnPressed{

    [_menu menuTapped];
    [_dateMenu hideView];

}

-(void)createTableView{
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, self.view.bounds.size.width, self.view.bounds.size.height-108-44) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[IncomeGoodsCell class] forCellReuseIdentifier:@"IncomeGoodsCell"];
    
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    _tbView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [_tbView.mj_header beginRefreshing];
    
    
    [self loadTypeMenu];
    
    _tbView.mj_footer = ({
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });



    
}


-(void)loadTypeMenu{


    [AFHttpTool getAllGoods:@"goods" progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        NSArray *dicArray = response[@"data"];
        
        for (NSDictionary *dic in dicArray) {
            
            AllGoodsModel *model = [[AllGoodsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.listArray addObject:model];
            
        }
        
        if (_rightBtn.hidden) {
            _rightBtn.hidden = NO;
        }
        
        
    } failure:^(NSError *err) {
        
    }];


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

    [AFHttpTool incomeGoods:Store_id brand_id:_brand_id start_time:_startTime end_time:_endTime page:_page progress:^
     
     (NSProgress *progress) {
        
    } success:^(id response) {

        
        if (_page == 1 && self.dataArray.count >0) {
            
            [self.dataArray removeAllObjects];
        }
        
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            [_tbView.mj_header endRefreshing];
            [_tbView.mj_footer endRefreshing];
            
            return;
        }
        
        
        if (_tbView.mj_footer.hidden) {
            _tbView.mj_footer.hidden = NO;
        }
        
        
        for (NSDictionary *dic in response[@"data"][@"incomelist"]) {
            
            IncomeGoodsModel *model = [[IncomeGoodsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
        }

        NSString *moneyString = [NSString stringWithFormat:@"¥ %@",response[@"data"][@"allsumamount"]];
        
        _moneyLabel.text = moneyString;

        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
        
            [_tbView.mj_footer endRefreshingWithNoMoreData];
        }else{


            [_tbView.mj_footer endRefreshing];
        }
        [_tbView.mj_header endRefreshing];
 
        _isLoading = NO;
        
        

        
        [self.tbView reloadData];
        
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"IncomeGoodsCell";
    
    IncomeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    IncomeGoodsModel *model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell configWithModel:model];
    
    return cell;
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 65;
}





#pragma perfectDelegete

-(NSInteger)menu:(PerfectMenu *)menu tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.listArray.count+1;
}



-(NSString *)menu:(PerfectMenu *)menu tableView:(UITableView *)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        return @"全部";
    }else{
    
    AllGoodsModel *model = _listArray[indexPath.row-1];
    
    return model.name;
    }
}



-(void)menu:(PerfectMenu *)menu tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        
        if (_dataArray.count>0) {
            [_dataArray removeAllObjects];
            
        }
        
        _brand_id = @"";
        
        [_tbView.mj_header beginRefreshing];
        
    }
    
}



-(NSInteger)menu:(PerfectMenu *)menu numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.listArray.count;

}



-(NSInteger)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    AllGoodsModel *model = _listArray[section];
    
    NSArray *array = model.brandlist;
    
    return array.count;
}


-(NSString *)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView titleForItemAtIndexPath:(NSIndexPath *)indexPath{

    AllGoodsModel *model = _listArray[indexPath.section];
    
    return model.name;
}


-(NSString *)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AllGoodsModel *model = _listArray[indexPath.section];

    return [model.brandlist[indexPath.row] objectForKey:@"logo"];
}



-(void)menu:(PerfectMenu *)menu collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    
    if (_dataArray.count>0) {
    [_dataArray removeAllObjects];
        
    }
 
    AllGoodsModel *model = _listArray[indexPath.section];
    
    _brand_id = [model.brandlist[indexPath.row] objectForKey:@"id"];
    
    [_tbView.mj_header beginRefreshing];
    

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    IncomeGoodsModel *model = self.dataArray[indexPath.row];
    
    GoodsDetailController * vc = [[GoodsDetailController alloc]init];
    
    vc.goods_id = model.sId;
    
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
