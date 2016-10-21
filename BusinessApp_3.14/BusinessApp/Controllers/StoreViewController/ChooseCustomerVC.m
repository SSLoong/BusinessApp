//
//  ChooseCustomerVC.m
//  BusinessApp
//
//  Created by wangyebin on 16/9/2.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ChooseCustomerVC.h"
#import "ChooseCustomerCell.h"
#import "OutputModel.h"
@interface ChooseCustomerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray * dataArray;//数据源
@property (weak, nonatomic) IBOutlet UITableView *tableView;//列表视图
@property (strong, nonatomic) UITextField * titleField;//搜索输入框
@property (assign, nonatomic) NSInteger page;//分页参数

@end

@implementation ChooseCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:10];
    [self loadDataConnect];
    
    
    
}
//初始化UI
- (void)initUI
{
    [self.tableView registerNib: [UINib nibWithNibName:NSStringFromClass([ChooseCustomerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ChooseCustomerCell class])];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.backgroundColor = RGB(240, 240, 240);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelection = NO;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _titleField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 220, 28)];
    [_titleField setCornerRadius:3.0];
    _titleField.textAlignment = NSTextAlignmentCenter;
    _titleField.font = [UIFont systemFontOfSize:14.0];
    _titleField.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleField;
    
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadDataConnect];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf loadDataConnect];
        //WYBLog(@"asdf");
    }];

    
    
}

//搜索
- (void)searchAction
{
    self.page = 1;
    [self loadDataConnect];
}


//网络连接
- (void)loadDataConnect
{
    self.view.userInteractionEnabled = NO;
    //NSArray * array = @[@"6902952883622"];
       [AFHttpTool storeCustomer:Store_id name:self.titleField.text page:[NSString stringWithFormat:@"%ld",(long)self.page] rows:@"10" progress:^(NSProgress * progress){
        
    } success:^(id response) {
        WYBLog(@"---%@",response);
        [self endRefresh];
        
        if ([response[@"code"] isEqualToString:@"0000"]) {
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:(NSArray *)response[@"data"]];
            [self.tableView reloadData];
            
        }else{
            [self.view showLoadingWithMessage:@"网络错误" hideAfter:2.0];
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
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseCustomerCell class]) forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    WS(weakSelf);
    cell.buttonBlock = ^(NSString *name,NSString *phone){
        weakSelf.changeBlock(name,phone);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    return cell;
}

@end
