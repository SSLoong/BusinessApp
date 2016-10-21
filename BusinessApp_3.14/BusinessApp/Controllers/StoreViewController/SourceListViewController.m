//
//  SourceListViewController.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/9/20.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SourceListViewController.h"
#import "WebViewJavascriptBridge.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AlipaySDK/AlipaySDK.h>

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height


@interface SourceListViewController ()<UIWebViewDelegate,UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property WebViewJavascriptBridge* bridge;

@property(nonatomic,strong)UIWebView *webView;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@end

@implementation SourceListViewController

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
    
    _webView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_webView];
    
    //开启调试信息
    //    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"back" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [_bridge registerHandler:@"camera" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
        
        [alertView show];
        
    }];
    
    [_bridge registerHandler:@"refresh" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self loadWebView];
    }];
    
    
    
    [_bridge registerHandler:@"pay" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        
        [self alipaySign:data[@"order_id"]];
        
    }];
    
    [self loadWebView];
    
    [self initViews];
}


-(void)alipaySign:(NSString *)order_id{
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"请稍后...";
    _hud.userInteractionEnabled = YES;
    
    [AFHttpTool alipaySign:order_id
     
                  progress:^(NSProgress *progress) {
                      
                  } success:^(id response) {
                      
                      if (!([response[@"code"]integerValue]==0000)) {
                          
                          NSString *errorMessage = response [@"msg"];
                          _hud.mode = MBProgressHUDModeCustomView;
                          _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                          _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                          [_hud hide:YES afterDelay:2];
                          
                          return;
                      }
                      
                      [_hud hide:YES];
                      
                      NSString *orderString = response[@"data"][@"sign"];
                      
                      NSString *appScheme = @"sjkshb";
                      
                      [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                          
                          
                      }];
                      
                      
                  } failure:^(NSError *err) {
                      
                      _hud.mode = MBProgressHUDModeCustomView;
                      _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                      _hud.labelText = @"error";
                      _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                      [_hud hide:YES afterDelay:2];
                      
                  }];
    
}



-(void)initViews{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(screen_width/2-15, screen_height/2-15, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}


- (void)loadWebView {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/purchase?shop_id=%@&list=1234",SITE_SERVER,Store_id];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [_webView loadRequest:req];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    bgImgView.image = [UIImage imageNamed:@"NavBarBj"];
    [self.view addSubview:bgImgView];
    
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"payResultNot" object:nil];

    // Do any additional setup after loading the view.
}

-(void)notice:(NSNotification *)not{
    
    NSString *str = not.userInfo[@"resultString"];
    
    [_bridge callHandler:@"paySuc" data:str];
    
}



-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


#pragma mark - alertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {return;}
    
    if (buttonIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Device has no camera"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = NO;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        
    } else {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //        imagePickerController.allowsEditing = YES;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}



#pragma mark - UIImagePickerController


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^ {
        
    }];
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^ {
        
        [self updatePortrait];
        
    }];
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)updatePortrait
{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
    _hud.labelText = @"正在上传图片";
    
    NSArray *nameArray = @[@"img"];
    
    NSDictionary *params = @{@"store_id":Store_id};
    
    NSArray *imageArray = [NSArray arrayWithObject:_image];
    
    [AFHttpTool uploadPictureWithURL:@"/app/image/upload" nameArray:nameArray imagesArray:imageArray params:params progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:5];
            
            return;
        }
        
        [self updataImage:response[@"data"]];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hud.labelText = @"上传成功";
        [_hud hide:YES afterDelay:2];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    
}

- (void)updataImage:(NSString *)imageString{
    
    [_bridge callHandler:@"cameraSuc" data:imageString];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
