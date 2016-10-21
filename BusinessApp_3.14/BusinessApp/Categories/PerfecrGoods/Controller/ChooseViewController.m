//
//  ChooseViewController.m
//  BusinessApp
//
//  Created by prefect on 16/5/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseTableViewCell.h"
#import "ChooseModel.h"
#import "RevisedPriceVC.h"
@interface ChooseViewController ()

@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic,strong) UILabel *subLabel;

@property (nonatomic,strong) UIButton *addBtn;

@property (nonatomic,assign) NSUInteger totalOrders;//总数

@property (nonatomic, assign) NSUInteger firstOrders;

@property (nonatomic, assign) NSUInteger secondOrders;

@property(nonatomic,copy)NSString *brand_id;

@property(nonatomic,copy)NSString *key;//购物车key

@property(nonatomic,copy)NSString *special_id;//特卖专场的id

@property(nonatomic,copy)NSString *sg_id;//商品ID

@property(nonatomic,copy)NSString *buy_num;//购买数量

@property(nonatomic,strong)NSMutableArray *generals;//普通商品

@property(nonatomic,strong)NSMutableArray *specials;//专场商品

@end

@implementation ChooseViewController

//懒加载数组
-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.tableView registerClass:[ChooseTableViewCell class] forCellReuseIdentifier:@"ChooseTableViewCell"];
    
    self.totalOrders = 0;
    
    [self creatFootView];
    
    
    
    [self loadData];
    
}

- (void)creatFootView{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44 -44, CGRectGetWidth(self.view.bounds), 44)];
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
    
    
    _addBtn = [UIButton new];
    [_addBtn setTitle:@"确 认" forState:UIControlStateNormal];
    _addBtn.backgroundColor = [UIColor grayColor];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(accountAction) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [footerView addSubview:_addBtn];
    
    
    [self setMoney];
    
    
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.mas_equalTo(0);
        
        
    }];
    
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(0);
        
        make.left.equalTo(_moneyLabel.mas_right).offset(10.f);
        
        
    }];
    
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.mas_equalTo(0);
        
        make.width.mas_equalTo(120);
        
        
    }];


}

-(void)setMoney{
    
    _moneyLabel.text = [NSString stringWithFormat:@"  购买个数：%lu",(unsigned long)self.totalOrders];
    
}

- (void)accountAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)loadData{


    [AFHttpTool SpecialGoods:Store_id
                    goods_id:_goods_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
    

        for (NSDictionary * dic in response[@"data"]) {
            ChooseModel * model = [[ChooseModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *err) {
        
        
        
    }];


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
                        
                    
                        [self setMoney];
                        
                    } failure:^(NSError *err) {
                        
                        NSLog(@"%@",err);
                        
                    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    ChooseModel *model = self.dataArray[indexPath.row];
    
    return [ChooseTableViewCell getHightWinthModel:model];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"ChooseTableViewCell";
    
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ChooseModel *model = self.dataArray[indexPath.row];
    
    NSString *special_id = [NSString stringWithFormat:@"%@",model.special_id];
    
    NSString *sg_id = [NSString stringWithFormat:@"%@",model.sg_id];
    
    cell.tag = indexPath.row;
    
    [cell configModel:model];
    
    
    
    
    
    
    
    cell.plusBlock = ^(NSInteger nCount,BOOL animated)
    {
        _special_id = @"";
        if (cell.tag == 0) {
            self.totalOrders =  self.secondOrders +nCount;
            self.firstOrders = nCount;
            [self setMoney];
        }else{
            self.totalOrders =  self.firstOrders + nCount;
            self.secondOrders = nCount;
            [self setMoney];
        }
            
        
            _sg_id = [NSString stringWithFormat:@"%@",model.sg_id];
        
//        if (animated) {
//            
//            _buy_num = @"+1";
//            
//        }else{
//            
//            if (model.orderCount == 1) {
//                
//                model.orderCount = 0;
//            }
//            
//            _buy_num = @"-1";
//        }
//        
//        [self addCart];
        if (animated) {

            if (self.didSelect) {
                self.didSelect(special_id,sg_id,@"+1");
            }
        }
        else
        {
            if (self.didSelect) {
                self.didSelect(special_id,sg_id,@"-1");
            }
        }
        
        //[self.navigationController popViewControllerAnimated:YES];
    };
    
    
    return cell;
    
}





@end
