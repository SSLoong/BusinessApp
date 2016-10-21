//
//  AppDelegate.m
//  BusinessApp
//
//  Created by prefect on 16/2/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Util.h"
#import "HomeViewController.h"
#import "ApplyViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "IQKeyboardManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMessage.h"


@interface AppDelegate ()<UIAlertViewDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //设置TbaBar
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0xFD5B44]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFD5B44]} forState:UIControlStateSelected];
    
    //设置导航背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBarBj"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
 
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
        //友盟分享
    [UMSocialData openLog:YES];
     [UMSocialData setAppKey:UmengAppKey];

    [UMSocialQQHandler setQQWithAppId:@"1105259197" appKey:@"wZz7oxlTNlf71KBW" url:@"http://www.appsjk.com"];
    
    [UMSocialWechatHandler setWXAppId:@"wxc882584cad26b32c" appSecret:@"c98c485e5568399985e20a18f9d9dda8" url:@"http://www.appsjk.com"];
    
  //友盟统计
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //[MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"57285caee0f55a9824000739";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //友盟推送
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"57285caee0f55a9824000739" launchOptions:launchOptions];
    
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    
    [UMessage registerForRemoteNotifications];
    
    //[UMessage setLogEnabled:YES];
    
    //判断是否已经登录
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"];
    
    if (!isLogin) {

        HomeViewController *homeVC = [[HomeViewController alloc] init];
        UINavigationController *_navi =
        [[UINavigationController alloc] initWithRootViewController:homeVC];
        self.window.rootViewController = _navi;
        
    }else{


        [AFHttpTool LoginWithPhone:LoginPhone pwd:LoginPwd progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            
            if (!([response[@"code"]integerValue]==0000)) {

                MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
                HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
                [self.window addSubview:HUD];
                [HUD show:YES];
                NSString *errorMessage = response [@"msg"];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                HUD.labelText = [NSString stringWithFormat:@"提示:%@", errorMessage];
                [HUD hide:YES afterDelay:3];
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];

            }
            
        } failure:^(NSError *err) {

            
        }];
        
    
    }
    
    
    
    [self appVersion];
    
    
    return YES;
}



-(void)appVersion{
    

    
    [AFHttpTool appVersion:@"iOS" os_version:[AppUtil getOSVersion] app_version:[AppUtil getAppVersion] progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        
        if([response[@"code"] integerValue] == 0000){
        
            
            NSString *title = [NSString stringWithFormat:@"发现新版本:%@",response[@"data"][@"version_no"]];
            
            NSString *update_content = response[@"data"][@"update_content"];
            
            NSString *cancelString = [response[@"data"][@"is_update"] integerValue] > 0 ? nil:@"忽略升级";
            
            [[[UIAlertView alloc] initWithTitle:title message:update_content delegate:self cancelButtonTitle:cancelString otherButtonTitles:@"现在升级", nil] show];
        
        }
        
    } failure:^(NSError *err) {
        
    }];


}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{


    if (alertView.numberOfButtons == 2 && buttonIndex==0) {
        
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1113280993?mt=8"]];
    
    
}



-(void)delayMethod{

                [DEFAULTS removeObjectForKey:@"store_id"];
                [DEFAULTS removeObjectForKey:@"isAdmin"];
                [DEFAULTS removeObjectForKey:@"isLogin"];
                [DEFAULTS removeObjectForKey:@"passWord"];
                [DEFAULTS synchronize];

                HomeViewController *homeVC = [[HomeViewController alloc] init];
                UINavigationController *_navi =
                [[UINavigationController alloc] initWithRootViewController:homeVC];
                self.window.rootViewController = _navi;

}






- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSString *resultString = [resultDic[@"resultStatus"] integerValue] == 9000 ? @"0000" : @"9999";
            
            [self sendResultString:resultString];
            
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {

            NSString *resultString = [resultDic[@"resultStatus"] integerValue] == 9000 ? @"0000" : @"9999";
            
            [self sendResultString:resultString];
            
        }];
    }
    
    [UMSocialSnsService handleOpenURL:url];
    
    return YES;
    
//    if (result == FALSE) {
//        
//    }
//    return result;
//    
    

}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSString *resultString = [resultDic[@"resultStatus"] integerValue] == 9000 ? @"0000" : @"9999";
            
            [self sendResultString:resultString];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSString *resultString = [resultDic[@"resultStatus"] integerValue] == 9000 ? @"0000" : @"9999";
            
            [self sendResultString:resultString];
            
        }];
    }
    
    return YES;
    
}


-(void)sendResultString:(NSString *)resultString{

    NSNotification * notice = [NSNotification notificationWithName:@"payResultNot" object:nil userInfo:@{@"resultString":resultString}];
    
    [[NSNotificationCenter defaultCenter]postNotification:notice];

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

@end
