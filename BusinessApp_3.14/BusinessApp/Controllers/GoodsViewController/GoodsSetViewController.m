//
//  GoodsSetViewController.m
//  BusinessApp
//
//  Created by perfect on 16/4/3.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsSetViewController.h"
#import "GoodsSetViewCell.h"
#import "SetModel.h"
#import "GoodsStateViewController.h"
#import "PerfectMenu.h"
#import "AllGoodsModel.h"

@interface GoodsSetViewController ()<UITableViewDelegate,UITableViewDataSource,PerfectMenuDataSource,PerfectMenuDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UITableView *tbView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSString *brand_id;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property (nonatomic, assign) BOOL isCompositor;

@property(nonatomic,strong)PerfectMenu *menu;

@property(nonatomic,strong) UIButton *leftBtn;//排序按钮

@property(nonatomic,strong) UIButton *rightBtn;//分类按钮

@property(nonatomic,strong)NSMutableArray *listArray;


@end

@implementation GoodsSetViewController

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//懒加载数组
-(NSMutableArray *)listArray{
    
    if(_listArray == nil){
        
        _listArray = [NSMutableArray array];
        
    }
    return _listArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"营销设置";
    
//    //添加手势，点击屏幕其他区域关闭键盘的操作
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
//    gesture.numberOfTapsRequired = 1;
//    gesture.delegate = self;
//    [self.view addGestureRecognizer:gesture];
    
    
    _page = 1;
    
    _brand_id = @"";
    
    self.isCompositor = YES;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self createChooseBtn];
    
    [self createTableView];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [_tbView.mj_header beginRefreshing];
    
}



-(void)createChooseBtn{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 43)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
//    self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 11, 50, 21)];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_leftBtn setTitle:@"库存 ⇩" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(compositorBtn) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.hidden = YES;
    [bgView addSubview:_leftBtn];

    
    
    
    
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
    
}

- (void)compositorBtn{
    if (_isCompositor) {
        [_leftBtn setTitle:@"库存 ⇧" forState:UIControlStateNormal];
        _isCompositor = NO;
    }else{
        [_leftBtn setTitle:@"库存 ⇩" forState:UIControlStateNormal];
        _isCompositor = YES;
    }


}

-(void)btnPressed{
    
    [_menu menuTapped];
    
}

-(void)createTableView{
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, self.view.bounds.size.width, self.view.bounds.size.height-108) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[GoodsSetViewCell class] forCellReuseIdentifier:@"GoodsSetViewCell"];
    
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


    [AFHttpTool GoodsStand:Store_id brand_id:_brand_id type:@"" sort:@"" page:_page progress:^(NSProgress *progress) {
        
    } success:^(id response) {


        if(_page ==1 && self.dataArray.count>0){
            
            [self.dataArray removeAllObjects];
        }
        
        if (_tbView.mj_footer.hidden) {
            _tbView.mj_footer.hidden = NO;
        }
        
        for (NSDictionary * dic in response[@"data"][@"list"]) {
            SetModel *model = [[SetModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
    
        _isLoading = NO;
        
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [_tbView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [_tbView.mj_footer endRefreshing];
            
        }
        
        
        if (_tbView.mj_header.isRefreshing) {
            
            [_tbView.mj_header endRefreshing];
        }

        
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * str = @"GoodsSetViewCell";
    
    GoodsSetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
    SetModel * model =  _dataArray[indexPath.row];
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [cell configModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SetModel * model =  _dataArray[indexPath.row];
    
    GoodsStateViewController * state = [[GoodsStateViewController alloc]init];
    
    state.money = [model.sub_amount integerValue];

    state.store_goods_id = model.store_goods_id;

    state.recommend = model.recommend;
    
    [self.navigationController pushViewController:state animated:YES];
    
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
