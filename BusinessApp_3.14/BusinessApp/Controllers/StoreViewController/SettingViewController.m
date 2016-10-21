//
//  SettingViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SettingViewController.h"
#import "ApplyViewController.h"
#import "HomeViewController.h"
#import "FeedbackViewController.h"
#import "DeliverRangesController.h"
#import "StoreInfoController.h"


@interface SettingViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation SettingViewController


- (void)viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"deliver"]integerValue] == 0) {
        
        //_sw.on = NO;
        [_sw setOn:NO];
        
    }else{
        //_sw.on = YES;
        [_sw setOn:YES];
    }
    

}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置";
    self.view .backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 15, [AppUtil getScreenWidth], 44);
    btn.backgroundColor = [UIColor colorWithHex:0xFD5B44];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = btn;
    
    self.sw = [[UISwitch alloc]init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"deliver"]integerValue] == 0) {
        
        //_sw.on = NO;
        [_sw setOn:NO];
        
    }else{
        //_sw.on = YES;
        [_sw setOn:YES];
    }

    
}


-(void)logoutAction{
    
    [DEFAULTS removeObjectForKey:@"store_id"];
    [DEFAULTS removeObjectForKey:@"isAdmin"];
    [DEFAULTS removeObjectForKey:@"isLogin"];
    [DEFAULTS removeObjectForKey:@"passWord"];
    [DEFAULTS removeObjectForKey:@"store_type"];
    [DEFAULTS synchronize];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *_navi =
    [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.view.window.rootViewController = _navi;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    
    
    UIImageView *avatar = [UIImageView new];
    avatar.image = [UIImage imageNamed:@"logo_setting"];
    [headerView addSubview:avatar];
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor grayColor];
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    nameLabel.text = [NSString stringWithFormat:@"V %@",ver];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:nameLabel];

    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 26));
        make.centerX.equalTo(headerView.mas_centerX);
        
    }];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(avatar.mas_bottom).offset(10);
        make.centerX.equalTo(headerView.mas_centerX);
         make.height.mas_equalTo(14);
        
    }];
    
    
    
    
    return headerView;

}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 20;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.text = @[@"清除缓存", @"建议反馈", @"修改密码",][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (0 == indexPath.row) {
        //清除缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否清理缓存？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 1011;
        [alertView show];
    }else if(indexPath.row == 2){
    
        ApplyViewController *vc = [[ApplyViewController alloc]init];
        
        vc.type = @"get";
        
        vc.reset = @"reset";
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (indexPath.row == 1){
    
        FeedbackViewController * vc = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1 && alertView.tag == 1011) {
        [self clearCache];
        
    }
}


//清理缓存
-(void) clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"缓存清理成功！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}



@end
