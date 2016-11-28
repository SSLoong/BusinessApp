//
//  GoodsStateViewController.m
//  BusinessApp
//
//  Created by perfect on 16/4/5.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsStateViewController.h"
#import "GoodsAddViewController.h"
#import "ShellListCell.h"


@interface GoodsStateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UISwitch * oneSwitch;

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation GoodsStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *releaseButon = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(saleAddBtn:)];
    self.navigationItem.rightBarButtonItem=releaseButon;
    
    [self createTableView];
}

- (void)saleAddBtn:(UIButton *)btn{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"SaleNum" bundle:nil];
    
    GoodsAddViewController *vc = [story instantiateViewControllerWithIdentifier:@"GoodsAddVC"];
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tableView setAllowsSelection:NO];
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"ShellListCell" bundle:nil]forCellReuseIdentifier:@"ShellListCellID"];

    
    //[self.tableView registerClass:[ShellListCell class] forCellReuseIdentifier:@"ShellListCellID"];

    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
//    _tableView.mj_header = ({
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.stateLabel.hidden = YES;
//        header;
//    });
//    [_tableView.mj_header beginRefreshing];
//    
//    
//    _tableView.mj_footer = ({
//        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        footer.refreshingTitleHidden = YES;
//        footer.hidden = YES;
//        footer;
//    });

}




-(void)addSet:(UIButton *)btn{

    _hud = [AppUtil createHUD];
    
    _hud.labelText = @"设置中...";
    
    _hud.userInteractionEnabled = NO;
    
    _recommend = _oneSwitch.on ? @"1":@"0";

    [AFHttpTool GoodsSetSubamount:_store_goods_id subamount:_textField.text store_id:Store_id recommend:_recommend progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }

        [_hud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShellListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShellListCellID"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ShellListCell" bundle:nil] forCellReuseIdentifier:@"ShellListCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ShellListCellID"];
    }
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_hud hide:YES];
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
