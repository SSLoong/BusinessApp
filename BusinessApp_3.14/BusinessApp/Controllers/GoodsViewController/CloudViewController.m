//
//  CloudViewController.m
//  BusinessApp
//
//  Created by prefect on 16/7/11.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "CloudViewController.h"
#import "WebViewJavascriptBridge.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface CloudViewController ()<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;

@property(nonatomic,strong)UIWebView *webView;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@end

@implementation CloudViewController


-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillDisappear:animated];
    
    if ([_activityView isAnimating]) {
        [_activityView stopAnimating];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_bridge) { return; }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    
    [self.view addSubview:_webView];
    
    //开启调试信息
    //    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"back" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
//    [_bridge registerHandler:@"camera" handler:^(id data, WVJBResponseCallback responseCallback) {
//        
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
//                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
//        
//        [alertView show];
//        
//    }];
    
    
    [_bridge registerHandler:@"refresh" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self loadWebView];
    }];
    
    
    [self loadWebView];
    
    [self initViews];
}


-(void)initViews{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screen_width/2-15, screen_height/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}


- (void)loadWebView {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/cloud?shop_id=%@",SITE_SERVER,Store_id];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [_webView loadRequest:req];
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    bgImgView.image = [UIImage imageNamed:@"NavBarBj"];
    [self.view addSubview:bgImgView];

    
}





#pragma Mark -webViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (![_activityView isAnimating]) {
        [_activityView startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([_activityView isAnimating]) {
        [_activityView stopAnimating];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"err" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:html baseURL:baseURL];
    
    
    if ([_activityView isAnimating]) {
        [_activityView stopAnimating];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
