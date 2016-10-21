//
//  CartViewController.m
//  BusinessApp
//
//  Created by prefect on 16/4/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CartViewController.h"
#import "SaleBrandModel.h"
#import "GoodsViewCell.h"
#import "GoodsModel.h"
#import "SpecialsViewCell.h"

#import "ChooseViewController.h"

#import "OrderCodeViewController.h"

@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *leftTableView;//左边表格

@property (nonatomic,strong) UITableView *rightTableView;//右边表格


@property (nonatomic,strong) NSMutableArray *leftArray;//左边数据源

@property (nonatomic,strong) NSMutableArray *dataArray;//普通商品数据源

@property (nonatomic,assign) NSUInteger totalOrders;//总数

@property(nonatomic,copy)NSString *brand_id;

@property(nonatomic,copy)NSString *key;//购物车key

@property(nonatomic,copy)NSString *special_id;//特卖专场的id

@property(nonatomic,copy)NSString *sg_id;//商品ID

@property(nonatomic,copy)NSString *buy_num;//购买数量

@property(nonatomic,assign)NSInteger money;

@property(nonatomic,assign)NSInteger subMoney;

@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic,strong) UILabel *subLabel;

@property (nonatomic,strong) UIButton *accountBtn;

@property(nonatomic,strong)NSMutableArray *generals;//普通商品

@property(nonatomic,strong)NSMutableArray *specials;//专场商品


@end

@implementation CartViewController

-(NSMutableArray *)generals{
    if (_generals == nil) {
        _generals = [NSMutableArray array];
    }
    return _generals;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"选择商品";
    
    self.view.backgroundColor = [UIColor whiteColor];

    _key = @"";
    
    _brand_id = @"";
    
    _money = 0;
    
    _subMoney = 0;
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/7*2, self.view.bounds.size.height - 44)];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.leftTableView];
    
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/7*2, 64, self.view.bounds.size.width/7*5, self.view.bounds.size.height - 64-44)];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    [self.rightTableView registerClass:[GoodsViewCell class] forCellReuseIdentifier:@"GoodsViewCell"];
    [self.rightTableView registerClass:[SpecialsViewCell class] forCellReuseIdentifier:@"SpecialsViewCell"];
    [self.view addSubview:self.rightTableView];
    
    

    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, CGRectGetWidth(self.view.bounds), 44)];
    footerView.backgroundColor = [UIColor blackColor];
 
    [self.view addSubview:footerView];
    
    
    _moneyLabel = [UILabel new];
    _moneyLabel.textColor = [UIColor whiteColor];

    _moneyLabel.font = [UIFont systemFontOfSize:18.f];
    [footerView addSubview:_moneyLabel];
    
    _subLabel = [UILabel new];
    _subLabel.textColor = [UIColor lightGrayColor];
    _subLabel.font = [UIFont systemFontOfSize:14.f];
    [footerView addSubview:_subLabel];
    
    
    _accountBtn = [UIButton new];
    [_accountBtn setTitle:@"生成订单码" forState:UIControlStateNormal];
    _accountBtn.backgroundColor = [UIColor grayColor];
    _accountBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_accountBtn addTarget:self action:@selector(accountAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_accountBtn];
    
    
    [self setMoney];
    
    
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.mas_equalTo(0);

        
    }];
    
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(0);
        
        make.left.equalTo(_moneyLabel.mas_right).offset(10.f);
        
        
    }];
    
    
    [_accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.mas_equalTo(0);
        
        make.width.mas_equalTo(120);
        
        
    }];
    
    [self loadLeftData];

}


-(void)accountAction{
    
    if (_money == 0) {
        
        return;
    }
    
    OrderCodeViewController *vc = [[OrderCodeViewController alloc]init];
    
    vc.money = _moneyLabel.text;
    
    vc.subMoney = _subLabel.text;
    
    vc.key = _key;
    
    vc.sgArr = self.dataArray;
    
    vc.generals = _generals;
    
    vc.specials = _specials;
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addCart{

    [AFHttpTool AddGoodsCart:_key
                    store_id:Store_id
                  special_id:_special_id
                       sg_id:_sg_id
                     buy_num:_buy_num
                      progress:^(NSProgress *progress) {
                          
                      } success:^(id response) {
                          
    

                          _money = [response[@"data"][@"total_amount"] integerValue];
                          _subMoney = [response[@"data"][@"sub_amount"] integerValue];
                          _generals = response[@"data"][@"generals"];
                          _specials = response[@"data"][@"specials"];
                          _key = response[@"data"][@"key"];
                          
                          
                          if (_money == 0) {
                              _accountBtn.backgroundColor = [UIColor grayColor];
                          }else{
                              _accountBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
                          }
                          
                          [self setMoney];
                          
                          [self.rightTableView reloadData];
                          
                      } failure:^(NSError *err) {
                          
                          NSLog(@"%@",err);
                          
                      }];

}


-(void)setMoney{

    _moneyLabel.text = [NSString stringWithFormat:@"  合计：¥%ld",(long)_money];

    _subLabel.text = [NSString stringWithFormat:@"已优惠¥%ld",(long)_subMoney];
}



-(void)loadLeftData{


    [AFHttpTool StoreSaleBrand:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {

       
        for (NSDictionary * dic in response[@"data"]) {
            SaleBrandModel * model = [[SaleBrandModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.leftArray addObject:model];
        }
        
        [self loadHotData];
        
        [self.leftTableView reloadData];
        
    } failure:^(NSError *err) {
        
    }];

}

//page需要更改
-(void)loadHotData{

    if (self.dataArray.count>0) {
        
        [self.dataArray removeAllObjects];
    }
    
    
    [AFHttpTool StoreSaleGoods:Store_id
                      brand_id:_brand_id
                          page:1
                      progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        for (NSDictionary *dic in response[@"data"]) {
                
                GoodsModel *model = [[GoodsModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
            
                if (model.type == 0) {
                    
                    model.orderCount = 0;
                }

                [self.dataArray addObject:model];
 
        }

        
        [self.rightTableView reloadData];
        
    } failure:^(NSError *err) {
        
        
    }];

}


#pragma mark - UITableViewDelegete


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.rightTableView])
    {
        return 60;
    }else{
    
        return 44;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([tableView isEqual:self.rightTableView]) {
        
        return self.dataArray.count;
    }else{
    
        return 1+self.leftArray.count;
    }
    
}


#pragma mark - private method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if ([tableView isEqual:self.leftTableView]) {
        
        static NSString *identifier = @"leftTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        UIView *sView = [[UIView alloc] init];
        sView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 44)];
        view.backgroundColor = [UIColor colorWithHex:0xFD5B44];
        [sView addSubview:view];
        
        cell.selectedBackgroundView = sView;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.separatorInset = UIEdgeInsetsZero;
        
        if (indexPath.row == 0) {

            UIImage *image =[UIImage imageNamed:@"hot"];
            cell.imageView.image = image;
            cell.textLabel.text = @"热销";
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

            
        }else{
        
            SaleBrandModel *model = _leftArray[indexPath.row-1];
            cell.textLabel.text = model.name;
            cell.imageView.image = nil;
        }
        
        return cell;
        
    }else{
        
        GoodsModel * model = self.dataArray[indexPath.row];
        
        if ([model.type integerValue] == 0) {
            
            static NSString * str = @"GoodsViewCell";
            
            GoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (NSDictionary *dic in _generals) {
                if ([dic[@"sg_id"] integerValue] == [model.sg_id integerValue]) {
                    
                    model.orderCount = [dic[@"buy_num"] integerValue];
                }
            }
            
            [cell configModel:model];
            
            cell.addBlock = ^(BOOL isAdd)
            {
                _special_id = @"";
                
                _sg_id = [NSString stringWithFormat:@"%@",model.sg_id];
                
                if (isAdd) {
                    
                    _buy_num = @"+1";
                    
                }else{
                    
                    if (model.orderCount == 1) {
                        
                        model.orderCount = 0;
                    }
                    
                    _buy_num = @"-1";
                }
                
                [self addCart];
                
            };
            
            return cell;
            
            
        }else{
        
            static NSString * str = @"SpecialsViewCell";
            
            SpecialsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [cell configModel:model];
            
            return cell;
        
        }
    }
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self.leftTableView]) {
        
        if(indexPath.row == 0){
        
            _brand_id = @"";
            
            [self loadHotData];
        }else{
        
            SaleBrandModel *model = self.leftArray[indexPath.row-1];
            
            _brand_id = [NSString stringWithFormat:@"%@",model.brand_id];
            
            [self loadHotData];
            
        }
        
    }else{
    
            GoodsModel * model = self.dataArray[indexPath.row];
        
        if ([model.type integerValue] > 0) {
            
            ChooseViewController *vc= [[ChooseViewController alloc]init];
            
            vc.money = self.money;
            
            vc.subMoney = self.subMoney;
            
            
            vc.goods_id = [NSString stringWithFormat:@"%@",model.goods_id];
            
            vc.titleString = model.goods_name;
            
            vc.didSelect = ^(NSString *special_id,NSString *sg_id,NSString *buy_num){
                
                _special_id = special_id;
                _sg_id =sg_id;
                _buy_num = buy_num;
                [self addCart];
                
            };
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    
    }

}



#pragma Mark -懒加载数据源

-(NSMutableArray *)leftArray{
    
    if (_leftArray == nil) {
        
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
