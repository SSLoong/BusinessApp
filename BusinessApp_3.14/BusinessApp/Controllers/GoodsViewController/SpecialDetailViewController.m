//
//  SpecialDetailViewController.m
//  BusinessApp
//
//  Created by AlexChang on 16/9/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpecialDetailViewController.h"
#import "SaleTableViewCell.h"
#import "SaleHeaderModel.h"
#import "GiftsModel.h"
#import "GoodsMesCell.h"
#import "GoodsTableViewCell.h"
#import "GoodsDataModel.h"
#import "SaleNumViewController.h"
#import "UMSocial.h"
#import "RewardTableViewCell.h"
#import "SourceViewController.h"
#import "ApplyForActivityVC.h"

#import "goodsDicModel.h"

@interface SpecialDetailViewController ()<UMSocialUIDelegate>
{
    NSInteger listCount;
}
@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *headerArray;

@property(nonatomic,strong)NSMutableArray *giftsArray;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)NSInteger isLoading;

@property(nonatomic,copy)NSString *titleString;

@property(nonatomic,copy)NSString *connt;

@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSMutableAttributedString *awardString;

@property(nonatomic,copy)NSString *stutaString;

@property (nonatomic,copy)NSString *rewardString;

@property (nonatomic, copy)NSString *type;
@end

@implementation SpecialDetailViewController

-(id)initWithStyle:(UITableViewStyle)style{
    
    self =  [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        self.tableView.separatorStyle = UITableViewStylePlain;
        [self.tableView registerClass:[SaleTableViewCell class] forCellReuseIdentifier:@"SaleTableViewCell"];
        [self.tableView registerClass:[GoodsMesCell class] forCellReuseIdentifier:@"GoodsMesCell"];
        [self.tableView registerClass:[GoodsTableViewCell class] forCellReuseIdentifier:@"GoodsTableViewCell"];
        [self.tableView registerClass:[RewardTableViewCell class] forCellReuseIdentifier:@"RewardTableViewCell"];
        
    }
    
    return self;
}
-(NSMutableAttributedString *)awardString{
    
    if (_awardString == nil) {
        
        _awardString = [[NSMutableAttributedString alloc]init];
        
    }
    return _awardString;
}

-(NSAttributedString *)attributedString:(NSString *)str{
    
    NSString *str1 = [NSString stringWithFormat:@" %@ ",str];
    
    NSDictionary *dictAttr = @{NSBackgroundColorAttributeName:[UIColor colorWithHex:0xF5F5F5]};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str1 attributes:dictAttr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(1, 2)];
    
    return attributedString;
}


-(NSMutableArray *)headerArray{
    
    if(_headerArray == nil){
        
        _headerArray = [NSMutableArray array];
        
    }
    return _headerArray;
}

-(NSMutableArray *)giftsArray{
    
    if(_giftsArray == nil){
        
        _giftsArray = [NSMutableArray array];
        
    }
    return _giftsArray;
}

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"专场详情";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    
    
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    
    self.tableView.mj_footer = ({
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        footer.hidden = YES;
        footer;
    });
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
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
    
    NSString *speciaID = [[NSString alloc]init];;
    
    if (self.special_id.length > 0) {
        speciaID = self.special_id;
    }else{
        speciaID = _model.special_id;
    }
    
    [AFHttpTool goodsSpecialDetail:Store_id special_id:speciaID page:_page progress:^(NSProgress *progress) {
        NSLog(@"%@",progress);
    } success:^(id response) {
        
        if(_page ==1 && self.dataArray.count>0){
            
            [self.headerArray removeAllObjects];
            [self.giftsArray removeAllObjects];
            [self.dataArray removeAllObjects];
            
        }
        
        if (self.tableView.mj_footer.hidden) {
            self.tableView.mj_footer.hidden = NO;
        }
        
        
        NSDictionary *dic = response[@"data"];
        
        if (_page == 1) {
            
            
            SaleHeaderModel *model = [[SaleHeaderModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.headerArray addObject:model];
            
            
            for (NSDictionary *dict in dic[@"giftslist"]) {
                
                GiftsModel *model = [[GiftsModel alloc]init];
                
                [model mj_setKeyValues:dict];
                
                [_giftsArray addObject:model];
                
            }
            
        }
        
        self.type = response[@"data"][@"pricetype"];
        
        NSArray *awardlist = response[@"data"][@"awardlist"];
        
        for (NSDictionary * dic in awardlist) {
            if (_stutaString.length>0) {
                break ;
            }
            //修改任务label格式
            NSMutableString *str = dic[@"award_title"];
            NSString *teStr = [str stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@" "];
            NSAttributedString *attributedSting = [self attributedString:teStr];
            [self.awardString appendAttributedString:attributedSting];
            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:@" "];
            [_awardString appendAttributedString:attStr];

        }
        
        _rewardString = [NSString stringWithFormat:@"%@元/瓶[最高%@元]",dic[@"award_num"],dic[@"upper_award_num"]];
        
        listCount = awardlist.count;
        
        goodsDicModel *goodDic = [[goodsDicModel alloc]init];
        [goodDic mj_setKeyValues:dic];
        
        if ([goodDic.activityresult integerValue] == 1) {
            _stutaString = [NSString stringWithFormat:@"累计奖励%@元 [任务已完成]",response[@"data"][@"awardresult"]];
        }else{
            _stutaString = [NSString stringWithFormat:@"累计奖励%@元 [任务未完成]",dic[@"awardresult"]];
        }
        
        
        
        
        
        for (NSDictionary *dict in dic[@"goodslist"]) {
            
            GoodsDataModel *model = [[GoodsDataModel alloc]init];
            
            [model mj_setKeyValues:dict];
            
            [_dataArray addObject:model];
            
        }
        
        _isLoading = NO;
        
        
        if(_page == [response[@"data"][@"totalPage"] integerValue] || [response[@"data"][@"totalPage"] integerValue] == 0){
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
        
        if (self.tableView.mj_header.isRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        
        [self.tableView reloadData];
        
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
        
        if (self.tableView.mj_footer.isRefreshing) {
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        if (self.tableView.mj_header.isRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
    }];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger num = listCount > 0 ? 1:0 ;
    
    switch (section) {
        case 0:
            return self.headerArray.count+self.giftsArray.count;
            
            break;
        case 1:
            if (_awardString !=nil) {
                return num;
            }
            return self.dataArray.count;
            break;
        case 2:
            return self.dataArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            static NSString *cellId = @"SaleTableViewCell";
            
            SaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            cell.type = self.model.goods_type;
            SaleHeaderModel *model = self.headerArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            [cell configModel:model];
            
            return cell;
            
        }else{
            
//            if (self.giftsArray.count == 0) {
            
//            }
            
            static NSString *cellId = @"GoodsMesCell";
            
            GoodsMesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            NSLog(@"%@",self.giftsArray[indexPath.row-1]);
            GiftsModel *model = self.giftsArray[indexPath.row-1];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            [cell configModel:model];
            
            return cell;
            
        }
        
    }else if (indexPath.section ==1){
        if (_awardString != nil) {
            static NSString *cellId = @"RewardTableViewCell";
            
            RewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor whiteColor];
            
            
            NSRange range = [_rewardString rangeOfString:@"/瓶[最高"];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_rewardString];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(_rewardString.length-1,1)];


            cell.completedLabel.attributedText =str;
            cell.rewardLabel.attributedText = _awardString;
            
            
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:_stutaString];
            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 4)];
            cell.stateLabel.attributedText = str1;
            
            return cell;
        }else{
            static NSString *cellId = @"GoodsTableViewCell";
            
            GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            GoodsDataModel *model = self.dataArray[indexPath.row];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            SaleHeaderModel *headerModel = [self.headerArray lastObject];
            
            [cell configModel:model nowstatus:[headerModel.nowstatus integerValue] spetype:[headerModel.spetype integerValue] changeType:self.type];
            
            cell.applyBtn.tag = indexPath.row;
            cell.purchaseBtn.tag = indexPath.row;
            
            [cell.applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.purchaseBtn addTarget:self action:@selector(purchaseEvent:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }else{
        static NSString *cellId = @"GoodsTableViewCell";
        
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        GoodsDataModel *model = self.dataArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SaleHeaderModel *headerModel = [self.headerArray lastObject];
        
        [cell configModel:model nowstatus:[headerModel.nowstatus integerValue] spetype:[headerModel.spetype integerValue] changeType:self.type];
        
        cell.applyBtn.tag = indexPath.row;
        cell.purchaseBtn.tag = indexPath.row;

        [cell.applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.purchaseBtn addTarget:self action:@selector(purchaseEvent:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
}


-(void)applyAction:(UIButton *)btn{
    

    GoodsDataModel *model = self.dataArray[btn.tag];
    
    SaleHeaderModel *headerModel = [self.headerArray lastObject];
    
    ApplyForActivityVC *vc = [[ApplyForActivityVC alloc]init];
    
    vc.real_price = model.real_price;
    
    vc.innum = model.in_num;

    vc.type = self.model.goods_type;
    
    vc.special_id = headerModel.special_id;
    
    vc.changeType = self.type;
    
    vc.dealer_id  = model.dealer_id;
    
    vc.goods_id = model.goods_id;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)purchaseEvent:(UIButton *)btn{

    SourceViewController *vc = [[SourceViewController alloc]init];
    GoodsDataModel *model = self.dataArray[btn.tag];
    vc.url_type = 1;
    vc.goods_id = model.goods_id;
    vc.dealer_id = model.dealer_id;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 60;
        }else{
            return 60;
        }
        
    }else if (indexPath.section == 1){
        
        if (_awardString !=nil) {
            return 180;
        }

        return 90;
    }else{
        return 90;
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_awardString == nil) {
        return 2;
    }
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 2;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
    
}




- (void)shareAction{
    
    _hud = [AppUtil createHUD];
    
    NSString *speciaID = [[NSString alloc]init];;
    
    if (self.special_id.length > 0) {
        speciaID = self.special_id;
    }else{
        speciaID = _model.special_id;
    }

    
    
    [AFHttpTool specialShare:Store_id special_id:speciaID progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:5];
            
            return;
        }
        
        _titleString = response[@"data"][@"title"];
        _url = response[@"data"][@"url"];
        _connt = response[@"data"][@"connt"];
        [self downloadImage:response[@"data"][@"img"]];
        
    } failure:^(NSError *err) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
    }];
    
    [AFHttpTool specialShareBack:Store_id special_id:_model.special_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        [self.tableView.mj_header beginRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *err) {
        
    }];
    
}


-(void)downloadImage:(NSString *)urlString{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:urlString]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            
                            if (finished) {
                                
                                if (image) {
                                    
                                    [self shareStore:image];
                                    [_hud hide:YES];
                                    
                                }else{
                                    
                                    [self shareStore:[UIImage imageNamed:@"icon"]];
                                    [_hud hide:YES];
                                    
                                }
                                
                            }
                            
                            
                            
                        }];
    
}

-(void)shareStore:(UIImage *)image{
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppKey
                                      shareText:_connt
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
    [UMSocialData defaultData].extConfig.qqData.url = _url;
    [UMSocialData defaultData].extConfig.qzoneData.url = _url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = _titleString;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _titleString;
    [UMSocialData defaultData].extConfig.qqData.title = _titleString;
    [UMSocialData defaultData].extConfig.qzoneData.title = _titleString;
}


//实现回调方法：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
        [AFHttpTool specialShareBack:Store_id special_id:_model.special_id progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            
            [self.tableView.mj_header beginRefreshing];
            
        } failure:^(NSError *err) {
            
            
        }];
        
        
        
    }
}


@end
