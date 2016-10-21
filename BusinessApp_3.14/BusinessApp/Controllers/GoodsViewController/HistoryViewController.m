//
//  HistoryViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/31.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryViewCell.h"
#import "HistoryModel.h"
#import "PerfectDate.h"
#import "DateView.h"
//#import "ActivityModel.h"
#import "SaleDetailViewController.h"

@interface HistoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,copy)NSString *start_time;

@property(nonatomic,copy)NSString *end_time;

@property(nonatomic,assign)BOOL isFrist;

@property(nonatomic,strong)PerfectDate *dateMenu;

@property(nonatomic,strong)DateView *dateView;

@end

@implementation HistoryViewController

-(id)init{

    self = [super init];
    if (self) {
        
        _start_time = [AppUtil getStartTime];
        
        _end_time = [AppUtil getEndTime];
        
        _isLoading = NO;
        
        _isFrist = YES;
        
        _page = 1;
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
    
    self.title = @"历史特卖";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBtn];
    
    [self createCollectionView];
    
}

-(void)createBtn{

    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bgView];

    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(44);
        
    }];
    
    
    _dateView = [[DateView alloc]initWithFrame:CGRectMake(10, 2, 180, 42)];
    [_dateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateAction)]];
    [bgView addSubview:_dateView];
    
    
    _dateMenu = [[PerfectDate alloc]initWithOrigin:CGPointMake(0, 108) andHeight:165];
    
    
    __weak typeof(self) weakSelf = self;
    
    _dateMenu.didSelectBtn = ^(NSString *startTime,NSString *endTime){
        
        
        weakSelf.dateView.sYearLabel.text = [NSString stringWithFormat:@"%@年",[startTime substringToIndex:4]];
        
        weakSelf.dateView.eYearLabel.text = [NSString stringWithFormat:@"%@年",[endTime substringToIndex:4]];
        
        NSRange range = NSMakeRange(5, 2);
        
        NSString *s1 = [startTime substringWithRange:range];
        
        NSString *s2 = [startTime substringFromIndex:8];
        
        weakSelf.dateView.sDateLabel.text = [NSString stringWithFormat:@"%@月%@日",s1,s2];
        
        
        NSString *e1 = [endTime substringWithRange:range];
        
        NSString *e2 = [endTime substringFromIndex:8];
        
        weakSelf.dateView.eDateLabel.text = [NSString stringWithFormat:@"%@月%@日",e1,e2];
        
        weakSelf.start_time = startTime;
        
        weakSelf.end_time = endTime;
        
        [weakSelf.collectionView.mj_header beginRefreshing];
        
        [weakSelf.dateMenu hideView];
        
    };
    
    [self.view addSubview:_dateMenu];


}


-(void)dateAction{
    
    [_dateMenu clickBtn];
    
}

-(void)createCollectionView{
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,108,[AppUtil getScreenWidth], [AppUtil getScreenHeight]-108) collectionViewLayout:flowayout];
    _collectionView.dataSource=self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    [_collectionView registerClass:[HistoryViewCell class] forCellWithReuseIdentifier:@"HistoryViewCell"];
    [self.view addSubview:_collectionView];
    
    _collectionView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [_collectionView.mj_header beginRefreshing];
    
    
    _collectionView.mj_footer = ({
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
    
    [AFHttpTool goodsSaleSpecial:Store_id
                      start_time:_start_time
                        end_time:_end_time
                            page:_page
    progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        if(_page ==1 && self.dataArray.count>0){
            
            [self.dataArray removeAllObjects];
        }
        

        for (NSDictionary * dic in response[@"data"][@"list"]) {
            HistoryModel * model = [[HistoryModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        

        _isLoading = NO;
        
        if (_isFrist) {
            _isFrist = NO;
        }
        
        
        if (self.dataArray.count > 0) {
            
            if (_collectionView.mj_footer.hidden) {
                _collectionView.mj_footer.hidden = NO;
            }
        }else{
            if (!_collectionView.mj_footer.hidden) {
                _collectionView.mj_footer.hidden = YES;
            }
        }
        
        
        
        
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [_collectionView.mj_footer endRefreshing];
            
        }
        
        if (_collectionView.mj_header.isRefreshing) {
            
            [_collectionView.mj_header endRefreshing];
        }
        
        _numLabel.text = [NSString stringWithFormat:@"%@",response[@"data"][@"totalCount"]];
        
        [_collectionView reloadData];
        
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
        
        if (_collectionView.mj_footer.isRefreshing) {
            
            [_collectionView.mj_footer endRefreshing];
            
        }
        if (_collectionView.mj_header.isRefreshing) {
            
            [_collectionView.mj_header endRefreshing];
        }
        
        
    }];
    
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_hud hide:YES];
}




- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (_isFrist) {
        return nil;
    }
    
    return [UIImage imageNamed:@"empty_placeholder"];
    
}



- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    if (_isFrist) {
        return nil;
    }
    
    NSString *text = @"暂无专场活动";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    
}



- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HistoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    HistoryModel *model = _dataArray[indexPath.row];
    
    [cell configModel:model];
    
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (self.view.bounds.size.width - 30)/2;
    
    CGFloat num;
    
    if ([AppUtil getScreenWidth] < 375 ) {
        
        num = 1.4;
    }else if([AppUtil getScreenWidth] == 375 ){
        
        num = 1.35;
    }else{
        
        num =1.3;
    }
    
    return CGSizeMake(w,w * num);
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
     HistoryModel *model= _dataArray[indexPath.row];
    
    SaleDetailViewController * vc= [[SaleDetailViewController alloc]init];
    
    vc.special_id = model.special_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
