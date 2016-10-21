//
//  ActivityViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/30.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityViewCell.h"
#import "ActivityModel.h"
#import "HistoryViewController.h"
#import "SaleDetailViewController.h"

@interface ActivityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isLoading;//是否在加载中

@property(nonatomic,assign)BOOL isFrist;

@end

@implementation ActivityViewController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"特卖活动";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isFrist = YES;
    
    [self createBtn];
    
    [self createCollectionView];
    
}

-(void)createCollectionView{
    
    UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,108,[AppUtil getScreenWidth], [AppUtil getScreenHeight]-108) collectionViewLayout:flowayout];
    _collectionView.dataSource=self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ActivityViewCell class] forCellWithReuseIdentifier:@"ActivityViewCell"];
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


    [AFHttpTool goodsSaleSpecial:Store_id page:_page progress:^(NSProgress *progress) {
        
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
            ActivityModel * model = [[ActivityModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        _isLoading = NO;
        
        _isFrist = NO;
        
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
    
            if (_collectionView.mj_footer.isRefreshing) {
                
                [_collectionView.mj_footer endRefreshing];
            }
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

        _isLoading = NO;
        
        _isFrist = NO;
        
        [_collectionView reloadData];
        
        if (_collectionView.mj_footer.isRefreshing) {
            
            [_collectionView.mj_footer endRefreshing];
            
        }
        if (_collectionView.mj_header.isRefreshing) {
            
            [_collectionView.mj_header endRefreshing];
        }
        
        
    }];



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



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ActivityModel *model = _dataArray[indexPath.row];
    
    SaleDetailViewController * vc= [[SaleDetailViewController alloc]init];
    
    vc.special_id = model.special_id;

    [self.navigationController pushViewController:vc animated:YES];

}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return self.dataArray.count;

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ActivityViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityViewCell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];

    ActivityModel *model = _dataArray[indexPath.row];
    
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



-(void)createBtn{
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bgView];
    
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
    otherLabel.text = @"个特卖专场可参加";
    [bgView addSubview:otherLabel];
    
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"历史特卖" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(lishiAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(44);
        
    }];
    
    
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
        
        make.size.mas_equalTo(CGSizeMake(72, 28));
        
        make.centerY.mas_equalTo(bgView.mas_centerY);
        
        make.right.mas_equalTo(-10);
        
    }];
    
}

-(void)lishiAction{
    
    HistoryViewController *vc = [[HistoryViewController alloc]init];
    
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
