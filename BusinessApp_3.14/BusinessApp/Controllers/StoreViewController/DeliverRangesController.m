//
//  DeliverRangesController.m
//  BusinessApp
//
//  Created by prefect on 16/3/23.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "DeliverRangesController.h"
#import "DeliverysViewCell.h"
#import "MinMoneyController.h"

@interface DeliverRangesController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,copy)UITextField * textField;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,copy)NSString *range1;

@property(nonatomic,copy)NSString *range2;

@property(nonatomic,copy)NSString *range3;

@property(nonatomic,copy)NSString *range4;

@end

@implementation DeliverRangesController

-(NSMutableArray *)dataArray{
    
    if(_dataArray == nil){
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"deliver"]integerValue] == 0) {
        
        //_sw.on = NO;
        [_sw setOn:NO];
        
    }else{
        //_sw.on = YES;
        [_sw setOn:YES];
    }
    
    
    
    [self reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"配送设置";

    _range1 =@"";
    
    _range2 =@"";
    
    _range3 =@"";
    
    _range4 =@"";
  
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[DeliverysViewCell class] forCellReuseIdentifier:@"DeliverysViewCell"];

    self.sw = [[UISwitch alloc]init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"deliver"]integerValue] == 0) {
        
        //_sw.on = NO;
        [_sw setOn:NO];
        
    }else{
        //_sw.on = YES;
        [_sw setOn:YES];
    }

    
    
}

-(void)reloadData{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
        [AFHttpTool StoreQueryDeliverys:Store_id progress:^(NSProgress *progress) {
    
        } success:^(id response) {


            
            if (!([response[@"code"]integerValue]==0000)) {
                
                NSString *errorMessage = response [@"msg"];
                _hud.mode = MBProgressHUDModeCustomView;
                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                [_hud hide:YES afterDelay:3];
                
                return;
            }
            
            
            NSDictionary *dict = response[@"data"];
                
            _range1 =dict[@"range1"];
            _range2 =dict[@"range2"];
            _range3 =dict[@"range3"];
            _range4 =dict[@"range4"];
            
            [_hud hide:YES];
            
            [self.tableView reloadData];
    
        } failure:^(NSError *err) {

            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = @"Error";
            _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
            [_hud hide:YES afterDelay:3];
            
            
        }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"DeliverysViewCell";
    
    DeliverysViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.section == 0) {
        cell.addressLabel.hidden = YES;
        cell.tLabel.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"配送服务";
        cell.accessoryView=self.sw;
        [self.sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    }else{
        cell.addressLabel.text = @[@"1千米以内", @"2千米以内", @"3千米以内",@"全城"][indexPath.row];
        cell.tLabel.text = @[_range1,_range2,_range3,_range4][indexPath.row];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MinMoney" bundle:nil];
    
    MinMoneyController *vc= [storyboard instantiateViewControllerWithIdentifier:@"MinMoneyVC"];
 
    vc.type = indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return 10;
}


- (void)switchAction:(UISwitch *)sw{
    _hud = [AppUtil createHUD];
    _hud.labelText = @"修改中";
    
    [AFHttpTool chanegStoreDeliver:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            
            if (self.sw.on) {
                
                self.sw.on = NO;
            }else{
                self.sw.on = YES;
            }
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        [DEFAULTS setObject:self.sw.on ? @1:@0  forKey:@"deliver"];
        [DEFAULTS setObject:self.sw.on ? @1:@0  forKey:@"status"];

        [_hud hide:YES];
        
    } failure:^(NSError *err) {
        
        if (self.sw.on) {
            
            self.sw.on = NO;
        }else{
            self.sw.on = YES;
        }
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
}


-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [_hud hide:YES];


}



@end
