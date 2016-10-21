//
//  OrderCodeViewController.m
//  BusinessApp
//
//  Created by prefect on 16/4/22.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderCodeViewController.h"
#import "GeneralViewCell.h"
#import "OrderDetailModel.h"
#import "specialModel.h"
#import "SpecialViewCell.h"
#import "GoodsModel.h"

#import "PayGeneralViewCell.h"
#import "GeneralsModel.h"

#import "PaySpecialViewCell.h"
#import "SpecialsModel.h"

#import "OrderDetailViewController.h"
#import "RevisedPriceVC.h"

@interface OrderCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *allView;

@property(nonatomic,strong)UIImageView *markImage;

@property(nonatomic,strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *subLabel;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;


@property(nonatomic,strong)NSMutableArray *generalArray;

@property(nonatomic,strong)NSMutableArray *specialArray;


@property(nonatomic,strong)UITableView *tbView;

@property (nonatomic, strong) NSTimer *myTimer;

@property (nonatomic, strong) NSTimer *orderTimer;


@end

@implementation OrderCodeViewController



-(NSMutableArray *)specialArray{
    
    if(_specialArray == nil){
        
        _specialArray = [NSMutableArray array];
        
    }
    return _specialArray;
}



-(NSMutableArray *)generalArray{
    
    if(_generalArray == nil){
        
        _generalArray = [NSMutableArray array];
        
    }
    return _generalArray;
}


-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(NSMutableArray *)generals{
    if (_generals == nil) {
        _generals = [NSMutableArray array];
    }
    return _generals;
}

-(NSMutableArray *)sgArr{
    
    if (_sgArr == nil) {
        
        _sgArr = [NSMutableArray array];
    }
    return _sgArr;
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_hud hide:YES];
}


//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开启定时器
    [_myTimer setFireDate:[NSDate distantPast]];
    
    [_orderTimer setFireDate:[NSDate distantPast]];
    
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //关闭定时器
    [_myTimer setFireDate:[NSDate distantFuture]];
    [_myTimer invalidate];
    
    [_orderTimer setFireDate:[NSDate distantFuture]];
    [_orderTimer invalidate];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"订单二维码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    [self loadCode];
    [self loadData];
    
}




-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)loadData{
    

    for (NSDictionary * dic in _generals) {
        
        GeneralsModel * model = [[GeneralsModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.generalArray addObject:model];
    }
    
    for (NSDictionary * dic in _specials) {
    
        SpecialsModel *model = [[SpecialsModel alloc]init];

        [model setValuesForKeysWithDictionary:dic];
        
        [self.specialArray addObject:model];
    }

    

    [self.tbView reloadData];
    

    
_myTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadCode) userInfo:nil repeats:YES];

    
_orderTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(orderResult) userInfo:nil repeats:YES];
 }




-(void)orderResult{

    [AFHttpTool orderResult:_key
                    progress:^(NSProgress *progress) {
                        
                    } success:^(id response) {

                        if (([response[@"code"]integerValue]==0000)) {
                            
                            [_myTimer setFireDate:[NSDate distantFuture]];
                            [_myTimer invalidate];
                            
                            [_orderTimer setFireDate:[NSDate distantFuture]];
                            [_orderTimer invalidate];
                    

                            OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
                            
                            vc.order_id = response[@"data"][@"order_id"];

                            vc.hidesBottomBarWhenPushed = YES;
                            
                            UITabBarController *tabbarVC = self.navigationController.viewControllers[0];
                            
                            [self.navigationController popToRootViewControllerAnimated:NO];
                            
                            [tabbarVC.navigationController  pushViewController:vc animated:YES];
                            
                        }
                        [_hud hide:YES];

                    } failure:^(NSError *err) {
                        
                        
                    }];

}

-(void)loadCode{

    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在加载";
    NSString *urlSring = [NSString stringWithFormat:@"%@/order/qrcode/weixin/%@?%@",SITE_SERVER,_key,[AppUtil getSystemTime]];
    [_markImage sd_setImageWithURL:[NSURL URLWithString:urlSring] placeholderImage:[UIImage imageNamed:@"logo_place"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            _markImage.image = [UIImage imageNamed:@"code_err"];
            [_hud hide:YES];
        }
        [_hud hide:YES];
    }];
    [_hud hide:YES];

}



-(void)createTableView{
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStyleGrouped];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tbView];
    
    [self.tbView registerClass:[PayGeneralViewCell class] forCellReuseIdentifier:@"PayGeneralViewCell"];
    
    [self.tbView registerClass:[PaySpecialViewCell class] forCellReuseIdentifier:@"PaySpecialViewCell"];

    self.tbView.tableHeaderView = [self customHeaderView];

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, CGRectGetWidth(self.view.bounds), 44)];
    footerView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:footerView];
    
    
    _moneyLabel = [UILabel new];
    _moneyLabel.text = _money;
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont systemFontOfSize:18.f];
    [footerView addSubview:_moneyLabel];
    
     _subLabel = [UILabel new];
    _subLabel.text = _subMoney;
    _subLabel.textColor = [UIColor lightGrayColor];
    _subLabel.font = [UIFont systemFontOfSize:14.f];
    [footerView addSubview:_subLabel];
    
    
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.mas_equalTo(0);
        
        
    }];
    
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(0);
        
        make.left.equalTo(_moneyLabel.mas_right).offset(10.f);
        
        
    }];

}

- (UIView *)customHeaderView{
    _allView = [UIView new];
    _allView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 204.0)];
    
    _markImage = [UIImageView new];
    _markImage.image = [UIImage imageNamed:@"store_big_header"];
    _markImage.backgroundColor = [UIColor whiteColor];
    [_allView addSubview:_markImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"商品明细";
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [_allView addSubview:_titleLabel];

    UIView *bgview = [UIView new];
    bgview.backgroundColor = [UIColor whiteColor];
    [_allView addSubview:bgview];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:65.0/255.0 blue:47.0/255.0 alpha:1.0f];
    [bgview addSubview:lineView];
    
    UILabel *label = [UILabel new];
    label.text = @"商品明细";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:10.f];
    [bgview addSubview:label];
    
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(bgview.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(10);
        make.centerY.mas_equalTo(bgview.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    
    
    [_markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(_allView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(14);
    }];

    return _allView;

}

#pragma mark - tableViewDelegete


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
    
        static NSString *cellId = @"PayGeneralViewCell";
        
        PayGeneralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GeneralsModel *model = self.generalArray[indexPath.row];
        
        [cell configModel:model];
        
        return cell;
        
    }else{
        
        SpecialsModel *sModel = self.specialArray[indexPath.section-1];
        
        if (indexPath.row<= sModel.goodses.count-1) {
            
            static NSString *cellId = @"PayGeneralViewCell";
            
            PayGeneralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary *dict = sModel.goodses[indexPath.row];
            
            GeneralsModel * model = [[GeneralsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dict];
            
            [cell configModel:model];
            
            return cell;
            
        }else{
            
            static NSString *cellId = @"PaySpecialViewCell";
            
            PaySpecialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell configModel:sModel];
            
            return cell;
            
            
        }
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    if (indexPath.section > 0) {
        
        SpecialsModel *model = self.specialArray[indexPath.section-1];
        
        if (indexPath.row >= model.goodses.count) {
            
            return 40;
        }
        
    }
    
    return 60;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1+self.specialArray.count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
        return self.generalArray.count;
    }else{
        
        SpecialsModel *model = self.specialArray[section-1];
        
        return model.goodses.count> 0 ? model.goodses.count+1 :0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 2.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        GeneralsModel *model = self.generalArray[indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RevisePriceStoryboard" bundle:nil];
        
        RevisedPriceVC *vc= [storyboard instantiateViewControllerWithIdentifier:@"RevisedPriceID"];
        
        vc.moneyStr = model.price;
        vc.key = self.key;
        vc.sg_id = model.sg_id;
        vc.special_id = @"";
        vc.type = 1;
        
        
        vc.changeBtnBlockOne = ^(NSMutableArray *generals,NSMutableArray *specials,NSInteger lastMoney,NSInteger subMoney,NSString *key,NSString *sg_id){
            
            self.moneyLabel.text =  [NSString stringWithFormat:@"  合计：¥%ld",(long)lastMoney];

            self.subLabel.text =[NSString stringWithFormat:@"  已优惠：¥%ld",(long)subMoney];
            
            self.key = key;
            self.generals = generals;
            
            self.specials = specials;
    
            [self.generalArray removeAllObjects];
            [self.specialArray removeAllObjects];
            
            [self loadData];

            [self.tbView reloadData];
        };
        
        
        [self.navigationController pushViewController:vc animated:YES];

        
    }else{
        SpecialsModel *sModel = self.specialArray[indexPath.section-1];
    
        if (indexPath.row<= sModel.goodses.count-1){
            NSDictionary *dict = sModel.goodses[indexPath.row];
            
            GeneralsModel * model = [[GeneralsModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dict];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RevisePriceStoryboard" bundle:nil];
            
            RevisedPriceVC *vc= [storyboard instantiateViewControllerWithIdentifier:@"RevisedPriceID"];
                        
            vc.moneyStr = model.price;
            
            vc.key = self.key;
            
            vc.sg_id = model.sg_id;

            vc.special_id = sModel.special_id;
            
            vc.type = 2;
            
            vc.changeBtnBlockTwo = ^(NSMutableArray *generals,NSMutableArray *specials,NSInteger lastMoney,NSInteger subMoney,NSString *key,NSString *sg_id){
                self.moneyLabel.text =  [NSString stringWithFormat:@"  合计：¥%ld",(long)lastMoney];
                
                self.subLabel.text =[NSString stringWithFormat:@"  已优惠：¥%ld",(long)subMoney];
                
                self.key = key;
                                
                self.generals = generals;
                
                
                self.specials = specials;
                
                [self.generalArray removeAllObjects];
                [self.specialArray removeAllObjects];
                
                [self loadData];
                
                [self.tbView reloadData];
            };
            
            

            [self.navigationController pushViewController:vc animated:YES];

        }else{
            return;
        }
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

