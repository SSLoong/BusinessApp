//
//  ScanAddViewController.m
//  BusinessApp
//
//  Created by prefect on 16/6/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "ScanAddViewController.h"
#import "UIImage+mask.h"
#import "AddGoodsViewController.h"
#import "OutputVC.h"
#import "AddGoodSTwoVC.h"

// 距顶部高度
#define Top_Height 0.2*kScreenHeight
// 中间View的宽度
#define MiddleWidth 0.8*kScreenWidth

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// tabBar 高度
#define kTabBarHeight 49.0f
// 导航栏高度
#define kNavigatHeight  64.f

static NSString *saoText = @"将酒品条形码放入框内，即可自动扫描";

@interface ScanAddViewController ()<UIAlertViewDelegate>
{
    bool _canOpen;
    
    MBProgressHUD *_hud;
}

@property (copy, nonatomic) NSString * code;//从条形码中识别出的信息(单次扫描)
@property (strong, nonatomic) NSMutableArray * dataArray;//多次扫描的结果都存放在这里

@end

@implementation ScanAddViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _dataArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _canOpen = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    //self.isPlural = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self creatBackGroundView];
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    [self setupCamera];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
    [_session stopRunning];
}

-(void)lineAnimation{
    CGFloat leadSpace = (kScreenWidth - MiddleWidth)/ 2;
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(leadSpace, Top_Height+2*num, MiddleWidth, 12);
        if (2*num >= MiddleWidth-12) {
            upOrdown = YES;
            _line.image = [UIImage imageNamed:@"Icon_SaoLineOn"];
        }
    }else {
        num --;
        _line.frame = CGRectMake(leadSpace, Top_Height+2*num, MiddleWidth, 12);
        if (num == 0) {
            upOrdown = NO;
            _line.image = [UIImage imageNamed:@"Icon_SaoLine"];
        }
    }
}


- (void)setupCamera{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Device
        if (!_device) {
            _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            // Input
            _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
            
            // Output
            _output = [[AVCaptureMetadataOutput alloc]init];
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
            // Session
            _session = [[AVCaptureSession alloc]init];
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            if ([_session canAddInput:self.input]){
                [_session addInput:self.input];
                _canOpen = YES;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回到主线程
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打开相机权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                    [alert show];
                });
            }
            if (_canOpen) {
                if ([_session canAddOutput:self.output]){
                    [_session addOutput:self.output];
                }
                // 条形码/二维码
                 _output.metadataObjectTypes =[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, nil];
                // 只支持二维码
//                _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
                
                // Preview
                _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
                _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回到主线程
                    _preview.frame =CGRectMake(0,0,kScreenWidth,kScreenHeight);
                    [self.view.layer insertSublayer:self.preview atIndex:0];
                });
            }
        }
        // Start
        if (_canOpen) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程
                timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
                [_session startRunning];
            });
        }
    });
}


#pragma mark  -- -- -- -- -- AVCapture Metadata Output Objects Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    if (self.isPlural) {
        [_session stopRunning];
        timer.fireDate = [NSDate distantFuture];
        [self.dataArray addObject:stringValue];
        [self.view showLoadingWithMessage:@"扫描成功" hideAfter:0.5];
        [self performSelector:@selector(startScan) withObject:nil afterDelay:0.5];
        
        
    }else{
        [_session stopRunning];
        [timer invalidate];
        timer = nil;
        self.code = stringValue;
        [self qrCode:stringValue];
    }
    
    
}

- (void)startScan
{
    [_session startRunning];
    timer.fireDate = [NSDate distantPast];

}

-(void)qrCode:(NSString *)codeString{
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"请稍后...";
    _hud.userInteractionEnabled = YES;
    
    [AFHttpTool GoodsScan:Store_id
                  barcode:codeString
     
                 progress:^(NSProgress *progress) {
        
                 } success:^(id response) {
                     
                     
                      WYBLog(@"%@",response);
                     
        if (![response[@"code"]isEqualToString:@"0000"]) {
            
            [_hud hide:YES];
            
            NSString *errorMessage = response [@"msg"];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:errorMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
                     
        [_hud hide:YES];
                     
                     NSString * type = response[@"data"][@"type"];
                     NSString * name = response[@"data"][@"goods_name"];
                     
                     if ([type isEqualToString:@"2"]) {
                         AddGoodSTwoVC * VC = VCWithStoryboardNameAndVCIdentity(@"SaleNum", @"AddGoodSTwoVC");
                         VC.code = self.code;
                         VC.name = name;
                         VC.goods_id = response[@"data"][@"goods_id"];
                         [self.navigationController pushViewController:VC animated:YES];
                        
                         
                     }else{
                         AddGoodsViewController * vc= [[AddGoodsViewController alloc]init];
                         vc.goods_id = response[@"data"][@"goods_id"];
                         
                         [self.navigationController pushViewController:vc animated:YES];
                         
                     }

            
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
}


#pragma mark - - UIAlertView Delegate - - - - - - - - - - - - - -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程
            timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
            [_session startRunning];
        });
        
        
        //        [self backAction];
    }else{
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        //        [self backAction];
    }
}


#pragma mark  -- -- -- -- -- MakeView

- (void)creatBackGroundView{
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    maskView.image = [UIImage maskImageWithMaskRect:maskView.frame clearRect:CGRectMake((kScreenWidth-MiddleWidth)/2, Top_Height, MiddleWidth, MiddleWidth)];
    [self.view addSubview:maskView];
}

- (void)creatUI{
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, Top_Height+MiddleWidth + 20, kScreenWidth, 35)];
    labIntroudction.numberOfLines = 2;
    labIntroudction.text = saoText;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labIntroudction];
    
    CGFloat leadSpace = (kScreenWidth - MiddleWidth)/ 2;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(leadSpace, Top_Height, MiddleWidth, MiddleWidth)];
    imageView.image = [UIImage imageNamed:@"Icon_SaoYiSao"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(leadSpace, Top_Height, MiddleWidth, 12)];
    _line.image = [UIImage imageNamed:@"Icon_SaoLine"];
    _line.contentMode = UIViewContentModeScaleToFill;
    
    
    if (self.isPlural) {
    
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAdd)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        
    }
    
    
    [self.view addSubview:_line];
}

- (void)finishAdd
{
    [_session stopRunning];
    timer.fireDate = [NSDate distantFuture];
    
    OutputVC * output = [[OutputVC alloc]init];
    output.argumentArr = self.dataArray;
    [self.navigationController pushViewController:output animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    if (timer) {
        [timer invalidate];
    }
    
}
@end

