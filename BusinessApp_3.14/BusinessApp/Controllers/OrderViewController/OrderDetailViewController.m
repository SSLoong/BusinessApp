//
//  OrderDetailViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailCell.h"
#import "OrderPayViewCell.h"
#import "OrderDetailModel.h"
#import "GoodsWayCell.h"
#import "OrderStateCell.h"
#import "LogisticsViewController.h"
#import "OrderPriceController.h"
#import "OrderSureController.h"
#import "DeliveryStateController.h"

static NSString *OrderDetCilcellId = @"OrderDetailCell";
static NSString *OrderPayCellId = @"OrderPayCell";
static NSString *GoodsWayCellId = @"GoodsWayCell";
static NSString *OrderStateCellId = @"OrderStateCell";



@interface OrderDetailViewController ()

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)NSString *total_goods;
@property(nonatomic,copy)NSString *real_amount;
@property(nonatomic,copy)NSString *total_subsidy;

@property(nonatomic,copy)NSString *pay_result;//支付结果
@property(nonatomic,copy)NSString *paychannel;

@property(nonatomic,copy)NSString *receive_type;//配送类型

@property(nonatomic,copy)NSString *receiver;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *recphone;//收货人手机


@property(nonatomic,copy)NSString *cust_id;//客户端id

@property(nonatomic,copy)NSString *buyphone;//购买人手机

@property(nonatomic,copy)NSString *status;//订单状态

@property(nonatomic,strong)MBProgressHUD *hud;
@end

@implementation OrderDetailViewController

-(id)initWithStyle:(UITableViewStyle)style{

    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        [self.tableView registerClass:[OrderDetailCell class] forCellReuseIdentifier:OrderDetCilcellId];
        [self.tableView registerClass:[OrderPayViewCell class] forCellReuseIdentifier:OrderPayCellId];
        [self.tableView registerClass:[GoodsWayCell class] forCellReuseIdentifier:GoodsWayCellId];
        [self.tableView registerClass:[OrderStateCell class] forCellReuseIdentifier:OrderStateCellId];
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
    
    self.title = @"订单详情";

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)loadData{

[AFHttpTool orderDetail:Store_id order_id:self.order_id progress:^(NSProgress *progress) {
    
} success:^(id response) {
    
    
    WYBLog(@"%@",response);
    
    if ( _dataArray.count > 0) {
        
        [self.dataArray removeAllObjects];
    }
    
    if (!([response[@"code"]integerValue]==0000)) {
        
        _hud = [AppUtil createHUD];
        NSString *errorMessage = response [@"msg"];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
        [_hud hide:YES afterDelay:3];
        
        return;
    }
    
    NSArray *dataArr = response[@"data"][@"orderdetaillist"];
    
    for (NSDictionary *dic in dataArr) {
        
        OrderDetailModel *model = [[OrderDetailModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [self.dataArray addObject:model];
        
    }
    
    NSDictionary *dataDic = response[@"data"];
    
    _total_goods =[NSString stringWithFormat:@"%@",dataDic[@"total_goods"]];
    
    _real_amount =[NSString stringWithFormat:@"¥%@",dataDic[@"real_amount"]];
    
    _total_subsidy =[NSString stringWithFormat:@"¥%@",dataDic[@"total_subsidy"]];
    
    _pay_result =dataDic[@"pay_result"];
    
    _buyphone = dataDic[@"buyphone"];
    
    _cust_id = dataDic[@"cust_id"];

    _paychannel =[NSString stringWithFormat:@"%@",dataDic[@"paychannel"]];

    if ([dataDic[@"receive_type"] integerValue] == 1) {
        _receive_type = @"自提";
    }else if([dataDic[@"receive_type"] integerValue] == 2) {
        _receive_type = @"店铺配送";
    }else{
        _receive_type = @"第三方配送";
    }
    

    _receiver =dataDic[@"receiver"];
    _address =dataDic[@"address"];
    _recphone =[NSString stringWithFormat:@"%@",dataDic[@"recphone"]];
    _status = dataDic[@"status"];
    
    [_hud hide:YES];

    [self.tableView.mj_header endRefreshing];
    
    [self.tableView reloadData];

} failure:^(NSError *err) {
    
    [self.tableView.mj_header endRefreshing];
    _hud = [AppUtil createHUD];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
    _hud.labelText = @"Error";
    _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
    [_hud hide:YES afterDelay:3];
    
}];




}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{


    [super viewWillDisappear:animated];
    
    [_hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row != self.dataArray.count) {
        return 75;
    }
    
    return 44;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count > 0 ? 5: 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return self.dataArray.count+1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section == 1) {
        return @"支付方式";
    }else if (section == 2) {
        return @"收货方式";
    }else if (section == 3) {
        return @"收货人信息";
    }else{
        return nil;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == self.dataArray.count) {
            
            OrderPayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderPayCellId forIndexPath:indexPath];
            
            cell.goodsNumLabel.text = _total_goods;
            cell.butieMoneyLabel.text = _total_subsidy;
            cell.shifuMoneyLabel.text = _real_amount;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else{
            
            OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderDetCilcellId forIndexPath:indexPath];
            
            OrderDetailModel *model = self.dataArray[indexPath.row];
            
            [cell configModel:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }else if(indexPath.section !=0 && indexPath.section !=4 ){

        
        GoodsWayCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsWayCellId forIndexPath:indexPath];
        
        if (indexPath.section ==1) {
            
            if (indexPath.row == 0) {
                cell.goodsLabel.text = @"付款状态";
                if ([_pay_result integerValue] == 1) {
                    cell.waysLabel.text = @"已付款";
                    cell.waysLabel.textColor=[UIColor colorWithHex:0x48B348];
                }else{
                    cell.waysLabel.text = @"未付款";
                    cell.waysLabel.textColor=[UIColor colorWithHex:0xFD5B44];
                }
            }else{
                cell.goodsLabel.text = @"付款方式";
                
                //WYBLog(@"%@",_paychannel);
                if ([_paychannel isEqualToString:@"alipay"]) {
                    cell.waysLabel.text = @"支付宝";
                }else if ([_paychannel isEqualToString:@"weixin"]){
                    cell.waysLabel.text = @"微信";
                }else{
                    cell.waysLabel.text = @"线下支付";
                }
                
                
            }
        }else if(indexPath.section ==2) {
                cell.goodsLabel.text = @"收货方式";
                cell.waysLabel.text = _receive_type;
        }else if(indexPath.section ==3) {
            

            if (indexPath.row == 0) {
                cell.goodsLabel.text = @"收货人";
                cell.waysLabel.text = _receiver;
            }else if (indexPath.row == 1){
                cell.goodsLabel.text = @"电话";
                cell.waysLabel.text = _recphone;
            }else{
                cell.goodsLabel.text = @"地址";
                cell.waysLabel.text = _address;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    }else{
    
    
        OrderStateCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderStateCellId forIndexPath:indexPath];
        cell.goodsLabel.text = _real_amount;

        if ([_status integerValue] != 1) {
            
            cell.sureBtn.hidden = NO;
            
            
            if([_pay_result integerValue] !=1){
            
                [cell.sureBtn setTitle:@"更改价格" forState:UIControlStateNormal];
  
            }else{
            
                if([_receive_type isEqualToString:@"自提"]){
                
                 [cell.sureBtn setTitle:@"确认订单" forState:UIControlStateNormal];
                
                }else{
                    
                    
                    
                    if([_status integerValue] == 0){
                        
                        [cell.sureBtn setTitle:@"选择配送" forState:UIControlStateNormal];
                        
                    }else if([_status integerValue] == 4){
                        
                        [cell.sureBtn setTitle:@"配送状态" forState:UIControlStateNormal];
                        
                    }

            }
                
            }
            
            [cell.sureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    
    }

}


-(void)btnAction:(UIButton *)btn{

    
    if ([btn.titleLabel.text isEqualToString:@"选择配送"]) {
        
        LogisticsViewController *vc= [[LogisticsViewController alloc]init];
        
        vc.order_id = self.order_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([btn.titleLabel.text isEqualToString:@"更改价格"]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderPrice" bundle:nil];
        

        OrderPriceController *vc= [storyboard instantiateViewControllerWithIdentifier:@"OrderPriceVC"];
        
        vc.order_id = self.order_id;
        
        vc.oldPrice = _real_amount;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([btn.titleLabel.text isEqualToString:@"确认订单"]) {
        
        
        _hud = [AppUtil createHUD];
        _hud.userInteractionEnabled = NO;
        _hud.labelText = @"发送验证码...";
        
        
        [AFHttpTool orderConfirmorder:self.order_id progress:^(NSProgress *progress) {
            
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
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderSure" bundle:nil];
            OrderSureController *vc= [storyboard instantiateViewControllerWithIdentifier:@"OrderSureVC"];
            
            vc.order_id = self.order_id;
            
            vc.buyPhone = _buyphone;
            
            vc.cust_id = _cust_id;

            [self.navigationController pushViewController:vc animated:YES];

            
        } failure:^(NSError *err) {
            
            
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
            [_hud hide:YES afterDelay:3];
            
        }];
        
    }else if([btn.titleLabel.text isEqualToString:@"配送状态"]) {
        
        DeliveryStateController *vc= [[DeliveryStateController alloc]init];

        vc.order_id = self.order_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section !=0 && section !=4) {
        return 25;
    }
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 5;
}


@end
