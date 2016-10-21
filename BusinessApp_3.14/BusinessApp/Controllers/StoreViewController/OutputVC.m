//
//  OutputVC.m
//  BusinessApp
//
//  Created by wangyebin on 16/8/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//  出库控制器

#import "OutputVC.h"
#import "OutputCell.h"
#import "OutputFooterView.h"
#import "ChooseCustomerVC.h"

@interface OutputVC ()

@property (strong, nonatomic) NSMutableArray * dataArray;//数据源
@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * phone;
@property (strong, nonatomic) OutputFooterView * footView;//底部视图

@end

@implementation OutputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
     self.dataArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self loadDataConnect];
    
    
    
}


//初始哈视图
- (void)initUI
{
    [self.tableView registerNib: [UINib nibWithNibName:NSStringFromClass([OutputCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OutputCell class])];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.backgroundColor = RGB(240, 240, 240);
    _footView = ViewFromNibName(@"OutputFooterView");
    WS(weakSelf);
    
    _footView.changeBlock = ^(NSString *name,NSString *phone){
        weakSelf.name = name;
        weakSelf.phone = phone;
       
    };
    _footView.buttonBlcok = ^(){
        
        [weakSelf chooseCustomer];
    };
    
    _footView.frame = CGRectMake(0, 0, 375, 140);
    self.tableView.tableFooterView = _footView;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确认出货" style:UIBarButtonItemStylePlain target:self action:@selector(sureOutput)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    

}

- (void)sureOutput
{
    
    [self.view endEditing:YES];
    if (self.dataArray.count == 0) {
        [self.view showLoadingWithMessage:@"没有商品可以出库" hideAfter:2.0];
        return;
    }
    
    NSMutableArray * mArray = [[NSMutableArray alloc]initWithCapacity:5];
    for (int i = 0; i < self.dataArray.count; i++) {
        OutputModel * model =self.dataArray[i];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:5];
        [dic setObject:model.sgid forKey:@"sgid"];
        [dic setObject:model.goods_id forKey:@"goods_id"];
        [dic setObject:model.dealer_id forKey:@"dealer_id"];
        [dic setObject:model.nPrice forKey:@"price"];
        [dic setObject:model.count forKey:@"num"];
        WYBLog(@"---%@",dic);
        [mArray addObject:dic];
    }
    
    NSString * mj_mArray = [mArray mj_JSONString];
    
    [AFHttpTool sureout:Store_id goodArray:mj_mArray phone:self.footView.phoneTef.text name:self.footView.nameTef.text progress:^(NSProgress * progress) {
        
    } success:^(id response) {
        
        if ([response[@"code"] isEqualToString:@"0000"]) {
            [[UIApplication sharedApplication].keyWindow showLoadingWithMessage:@"出库成功" hideAfter:2.0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString * str = response[@"msg"];
            [self.view showLoadingWithMessage:str hideAfter:2.0];

        }
        
        WYBLog(@"%@",response);
        
    } failure:^(NSError * error) {
        
    }];
    
}
- (void)chooseCustomer
{
    ChooseCustomerVC * vc = VCWithStoryboardNameAndVCIdentity(@"StoreInfo", @"ChooseCustomerVC");
    WS(weakSelf);
    vc.changeBlock = ^(NSString * name,NSString *phone){
        weakSelf.footView.nameTef.text = name;
        weakSelf.footView.phoneTef.text = phone;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//网络连接
- (void)loadDataConnect
{
    self.view.userInteractionEnabled = NO;
    //NSArray * array = @[@"6902952883622"];
    NSString * str =  [self.argumentArr mj_JSONString];
    
    WYBLog(@"%@",self.argumentArr);
    [AFHttpTool output:Store_id codeArray:str progress:^(NSProgress * progress){
        
    } success:^(id response) {
        WYBLog(@"---%@",response);
        [self endRefresh];
        if ([response[@"code"] isEqualToString:@"0000"]) {
            NSArray * array = response[@"data"];
            for (int i = 0; i < array.count; i++) {
                OutputModel * itemData = [[OutputModel alloc]init];
                [itemData setValuesForKeysWithDictionary:array[i]];
                
                [self.dataArray addObject:itemData];
            }
            
            [self.tableView reloadData];

            
           
            
        }else{
            [self.view showLoadingWithMessage:response[@"msg"] hideAfter:2.0];
        }
        
    } failure:^(NSError * error) {
        WYBLog(@"%@",error.description);
        [self endRefresh];
        //        WYBLog(@"%@",error.description);
    }];
    
}


//结束刷新
- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.view.userInteractionEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --数据源和代理方法


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutputCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OutputCell class]) forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}


@end
