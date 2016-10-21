//
//  DeliveryStateController.m
//  BusinessApp
//
//  Created by prefect on 16/3/28.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "DeliveryStateController.h"
#import "DeliveryModel.h"
#import "LogisticsViewController.h"

@interface DeliveryStateController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,copy)NSString *carrier;

@property(nonatomic,copy)NSString *mailno;

@end

@implementation DeliveryStateController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"配送详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self loadData];
}


-(void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [AppUtil getScreenWidth], self.view.bounds.size.height-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    [self.tableView registerClass:[OrderViewCell class] forCellReuseIdentifier:@"OrderViewCell"];

}






-(void)loadData{

    _hud = [AppUtil createHUD];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = @"请稍等...";
    
    [AFHttpTool orderExpress:self.order_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        NSLog(@"%@",response);
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        _carrier = response[@"data"][@"carrier"];
        
        _mailno = response[@"data"][@"mailno"];
        
        if([response[@"data"][@"status"] integerValue] >= 5){

            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新配送" style:UIBarButtonItemStylePlain target:self action:@selector(reDelivery)];
        }
        
    
        NSArray *dicArray = response[@"data"][@"logisticsinfo"];
        
        for (NSDictionary *dic in dicArray) {
          
            DeliveryModel *model = [[DeliveryModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
        }
        
        [_hud hide:YES];
        
        [self createTableView];
        
    } failure:^(NSError *err) {
        
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
}

-(void)reDelivery{

    UIViewController *ctrl = self.navigationController.viewControllers[1];
    
    [self.navigationController popToViewController:ctrl animated:NO];
    
    LogisticsViewController *vc = [[LogisticsViewController alloc]init];
    
    vc.order_id = _order_id;
    
    [ctrl.navigationController pushViewController:vc animated:NO];

}


#pragma mark - tableViewDelegate&&dataSouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return _mailno.length>0 ? 2:1;
            break;
        case 1:
            return _dataArray.count;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {

    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14.0f];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"承运人";
            cell.detailTextLabel.text = _carrier;
            break;
        case 1:
            cell.textLabel.text = @"运单号";
            cell.detailTextLabel.text = _mailno;
            break;
        default: break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
        
    }else{
    
    
        static NSString *cellIdentifier=@"UITableViewCellIdentifier";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!cell){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font=[UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"order_map"];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"order_point"];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        
        DeliveryModel *model = _dataArray[indexPath.row];
        
        cell.textLabel.text = model.context;
        
        cell.detailTextLabel.text = model.time;
        
        return cell;
    
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return 44;
            break;
        case 1:
            return 60;
            break;
        default:
            return 0;
            break;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return @"订单配送跟踪";
            break;
        default:
            return nil;
            break;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 0.01;
            break;
        case 1:
            return 30;
            break;
        default:
            return 0;
            break;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
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
