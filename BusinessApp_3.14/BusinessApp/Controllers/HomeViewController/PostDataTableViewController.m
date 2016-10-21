//
//  PostDataTableViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/3.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "PostDataTableViewController.h"
#import "TypeViewController.h"
#import "AreaViewController.h"
#import <ReactiveCocoa.h>
#import "UploadViewController.h"

@interface PostDataTableViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UITextField *dianpuFiled;

@property (weak, nonatomic) IBOutlet UITextField *gongsiFiled;

@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;

@property (weak, nonatomic) IBOutlet UITextField *fuzeFiled;

@property (weak, nonatomic) IBOutlet UITextField *addressFiled;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property(nonatomic,copy)NSString *city_code;

@property(nonatomic,copy)NSString *dealer_id;

@property(nonatomic,copy)NSString *province;

@property(nonatomic,copy)NSString *city;

@property(nonatomic,copy)NSString *area;

@end

@implementation PostDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    RACSignal *valid = [RACSignal combineLatest:@[self.dianpuFiled.rac_textSignal, self.gongsiFiled.rac_textSignal,self.phoneFiled.rac_textSignal,self.fuzeFiled.rac_textSignal,self.addressFiled.rac_textSignal]
                                         reduce:^(NSString *dianpu,NSString *gongsi,NSString *phone,NSString *fuze,NSString *address) {
                                             return @(dianpu.length > 0 && gongsi.length > 0 && phone.length > 0 && fuze.length > 0 && address.length > 0);
                                         }];
    RAC(self.nextBtn, enabled) = valid;
    RAC(self.nextBtn, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];

    
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"areaNotice" object:nil];
    [center addObserver:self selector:@selector(notice1:) name:@"storesNotice" object:nil];
    
}


-(void)notice:(NSNotification *)not{
    
    self.province = not.userInfo[@"province"];
    
    self.city = not.userInfo[@"city"];
    
    self.area = not.userInfo[@"area"];
    
    self.city_code = not.userInfo[@"code"];
    
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.area];

}

-(void)notice1:(NSNotification *)not{
    
    self.dealer_id = not.userInfo[@"dealer_id"];
    
    self.TypeLabel.text =  not.userInfo[@"type"];;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 7;
            break;
            case 1:
            return 1;
        default:
            return 0;
            break;
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 40;
            break;
        case 1:
            return 1;
        default:
            return 0;
            break;
    }
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 0) {

        if (indexPath.row == 4) {
            
            AreaViewController *areaVC = [[AreaViewController alloc]init];

            [self.navigationController pushViewController:areaVC animated:YES];
            
        }
        
        if (indexPath.row == 6) {
            
            
            if (self.areaLabel.text.length == 0) {
                
                _hud = [AppUtil createHUD];
                
                _hud.userInteractionEnabled = YES;
                
                _hud.mode = MBProgressHUDModeCustomView;
                
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"请先选择地区"];
                
                [_hud hide:YES afterDelay:3];
                
                return;
            }
            
            
            TypeViewController *typeVC = [[TypeViewController alloc]init];
            
            typeVC.cityCode = self.city_code;
            
            typeVC.chooseType = ^(NSString *typeString){
            
                self.TypeLabel.text = typeString;
                
            };
            
            [self.navigationController pushViewController:typeVC animated:YES];
            
        }
        
    }


}


- (IBAction)nextAction:(id)sender {
    
    
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
    
    if(self.city_code.length == 0){

        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请先选择地区"];
        [_hud hide:YES afterDelay:3];
        return;
    }
    
    if(self.TypeLabel.text.length == 0){
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请先选择商户类型"];
        [_hud hide:YES afterDelay:3];
        return;
    }

    NSString *type;
    
    NSString *dealer_id;
    
    if ([self.TypeLabel.text isEqualToString:@"连锁"]) {
        
        type = @"3";
        dealer_id = self.dealer_id;
    }else{
        type = @"2";
        dealer_id = @"";
    }
    
    [AFHttpTool storeComplete:self.store_id
                         name:_dianpuFiled.text
                 company_name:_gongsiFiled.text
                      contact:_fuzeFiled.text
                        phone:_phoneFiled.text
                     province:self.province
                         city:self.city
                         area:self.area
                      address:_addressFiled.text
                         type:type
                    site_code:self.city_code
                    dealer_id:dealer_id
                     progress:^(NSProgress *progress) {
        
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
        
        UploadViewController *vc = [[UploadViewController alloc]init];
        
        vc.store_id = self.store_id;
        
        [self.navigationController pushViewController:vc animated:YES];
        

        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
  

}


@end
