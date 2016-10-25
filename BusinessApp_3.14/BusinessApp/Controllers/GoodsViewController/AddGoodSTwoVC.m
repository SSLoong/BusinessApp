//
//  AddGoodSTwoVC.m
//  BusinessApp
//
//  Created by wangyebin on 16/8/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AddGoodSTwoVC.h"

@interface AddGoodSTwoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;//滚动视图作为父视图
@property (weak, nonatomic) IBOutlet UITextField *nameTef;//商品名称
@property (weak, nonatomic) IBOutlet UITextField *codeTef;//条形码
@property (weak, nonatomic) IBOutlet UITextField *sPrice;//市场价
@property (weak, nonatomic) IBOutlet UITextField *jPrice;//进价
@property (weak, nonatomic) IBOutlet UITextField *salePrice;//售价
@property (weak, nonatomic) IBOutlet UITextField *countTef;//数量

@property (weak, nonatomic) IBOutlet UIView *imageBackView;//添加图片白色背景
@property (strong, nonatomic) UIButton * addImageBtn;//添加图片按钮
@property (strong, nonatomic) NSMutableArray * imagesArr;//存放图片的数组;
@property (strong, nonatomic) NSString * imageUrl;//图片URL

@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation AddGoodSTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.imagesArr = [[NSMutableArray alloc]initWithCapacity:3];
   
    // Do any additional setup after loading the view.
}

//初始化UI
- (void)initUI
{
    self.navigationItem.title = @"添加库存";
    
    self.codeTef.text = self.code;
    self.nameTef.text = self.name;
    self.codeTef.userInteractionEnabled = NO;
    
    self.scrollView.backgroundColor = RGB(240, 240, 240);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(-68, 0, 0, 0);
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"确认添加" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    UIFont * font = [UIFont systemFontOfSize:14];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    [right setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
    
    
    UILabel * imageLab = [[UILabel alloc]init];
    imageLab.text = @"商品图片";
    imageLab.font = [UIFont systemFontOfSize:15.0];
    [self.imageBackView addSubview:imageLab];
    [imageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(70, 45));
        
    }];
    
    self.addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageBtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.addImageBtn setBackgroundColor:RGB(252, 134, 7)];
    [self.addImageBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.addImageBtn setCornerRadius:5.0];
    //[self.addImageBtn setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [self.imageBackView addSubview:self.addImageBtn];
    [self.addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(15/375.0*ScreenWidth);
        make.size.mas_equalTo(CGSizeMake(75/375.0*ScreenWidth, 75/375.0*ScreenWidth));
        
    }];
    
    
    
}

//添加图片
- (void)addImage
{
//    // 判断当前的sourceType是否可用
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        // 实例化UIImagePickerController控制器
//        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
//        // 设置资源来源（相册、相机、图库之一）
//        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
//        // 如果选择的是视屏，允许的视屏时长为20秒
//        imagePickerVC.videoMaximumDuration = 20;
//        // 允许的视屏质量（如果质量选取的质量过高，会自动降低质量）
//        imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
//        
//        // 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
//        imagePickerVC.delegate = self;
//        // 是否允许编辑（YES：图片选择完成进入编辑模式）
//        imagePickerVC.allowsEditing = YES;
//        // model出控制器
//        [self presentViewController:imagePickerVC animated:YES completion:nil];
    //}
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
    
    [alertView show];
}


//提示框代理
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
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            //imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        
    } else {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        //imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}


//点击确认
- (void)complete
{
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"添加中...";
    _hud.userInteractionEnabled = NO;
    
    if(_sPrice.text.length == 0){
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请输入市场价";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
    if(_jPrice.text.length == 0){
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请输入进货价";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
    if(_salePrice.text.length == 0){
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请输入售价";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
    if(_countTef.text.length == 0){
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请输入数量";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
    [self upImagesConnection];
    
}
- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // 选择的图片信息存储于info字典中
    //WYBLog(@"%@", info);
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self.imagesArr addObject:image];
//    if (self.imagesArr.count > 3) {
//        [self.imagesArr removeObjectAtIndex:2];
//    }
    [self upDateImage];
}

- (void)upDateImage
{
    for (int i = 0; i < self.imagesArr.count; i++) {
        UIImage * image = _imagesArr[i];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        [imageView setCornerRadius:5.0];
        [self.imageBackView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.size.mas_equalTo(CGSizeMake(75/375.0*ScreenWidth, 75/375.0*ScreenWidth));
            make.left.mas_equalTo(90/375.0 * ScreenWidth * i + 15/375.0 * ScreenWidth);
        }];
        
        
        
        [_addImageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.size.mas_equalTo(CGSizeMake(75/375.0*ScreenWidth, 75/375.0*ScreenWidth));
            make.left.mas_equalTo(90/375.0 * ScreenWidth * self.imagesArr.count + 15/375.0 * ScreenWidth);

        }];
        
    }

}


//上传图片
- (void)upImagesConnection
{
    
    _hud.userInteractionEnabled = YES;
    _hud.labelText = @"正在上传图片";
    
    NSMutableArray *nameArray = [[NSMutableArray alloc]initWithCapacity:1];
    for (int i = 0; i < self.imagesArr.count; i++) {
        [nameArray addObject:[NSString stringWithFormat:@"%@",@"goods_img"]];
    }

    
    NSDictionary *params = @{@"store_id":Store_id};
        NSArray *imageArray = [NSArray arrayWithArray:self.imagesArr];
    
    [AFHttpTool uploadPictureWithURL:@"/goods/upload/img" nameArray:nameArray imagesArray:imageArray params:params progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        WYBLog(@"%@",response);
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:5];
            
            return;
        }

        [_hud hide:YES];
        self.imageUrl = response [@"data"];
        [self SubmitConnetion];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
}


//入库
- (void)SubmitConnetion
{
    [AFHttpTool GoodsAdd:Store_id
               good_name:_nameTef.text
                 barcode:_codeTef.text
               goods_img:self.imageUrl
                goods_id:self.goods_id
                   price:_jPrice.text
              real_price:_sPrice.text
          purchase_price:_salePrice.text
                   stock:_countTef.text
                progress:^(NSProgress *progress) {
                    
                    
                } success:^(id response) {
                    WYBLog(@"%@",response);
                    if (!([response[@"code"]integerValue]==0000)) {
                        
                        NSString *errorMessage = response [@"msg"];
                        _hud.mode = MBProgressHUDModeCustomView;
                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                        _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                        [_hud hide:YES afterDelay:2];
                        
                        return;
                    }
                    
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                    _hud.labelText = @"添加成功";
                    [_hud hide:YES afterDelay:2];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *err) {
                    
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    _hud.labelText = @"Error";
                    _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                    [_hud hide:YES afterDelay:2];
                    
                }];

}


@end
