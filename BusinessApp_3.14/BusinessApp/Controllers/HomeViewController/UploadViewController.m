//
//  UploadViewController.m
//  BusinessApp
//
//  Created by perfect on 16/4/7.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "UploadViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface UploadViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property(nonatomic,strong)UILabel * hintLabel;

@property(nonatomic,strong)UIImageView * frontImage;

@property(nonatomic,strong)UIImageView * versoImage;

@property(nonatomic,strong)UIImageView * busineImage;

@property(nonatomic,strong)UIImageView * healthImage;

@property(nonatomic,strong)UIView * lineView ;

@property(nonatomic,strong)UILabel * storeLabel;

@property(nonatomic,strong)UIImageView * logoImage;

@property(nonatomic,strong)UIButton * applyBtn;

@property (nonatomic, strong) UIImage *image1;

@property (nonatomic, strong) UIImage *image2;

@property (nonatomic, strong) UIImage *image3;

@property (nonatomic, strong) UIImage *image4;

@property (nonatomic, strong) UIImage *image5;

@property(nonatomic,copy)NSString *imageInfo;

@property(nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"上传证件";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _imageArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];

    [self createView];
}

-(void)createView{
    
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, self.view.bounds.size.width-15, 14)];
    _hintLabel.text = @"请确保您的申请材料真实有效,以便快速审核";
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_hintLabel];
    
    
    CGFloat w = (self.view.bounds.size.width-45)/2;
    
    CGFloat h = w*160/330;
    
    _frontImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44, w, h)];
    _frontImage.backgroundColor = [UIColor whiteColor];
    _frontImage.image = [UIImage imageNamed:@"home_front"];
    _frontImage.userInteractionEnabled = YES;
    [_frontImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction1)]];
    [self.view addSubview:_frontImage];
    
    _versoImage = [[UIImageView alloc]initWithFrame:CGRectMake(w+30, 44, w, h)];
    _versoImage.backgroundColor = [UIColor whiteColor];
    _versoImage.image = [UIImage imageNamed:@"home_verso"];
    _versoImage.userInteractionEnabled = YES;
    [_versoImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction2)]];
    [self.view addSubview:_versoImage];
    
    _busineImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, h+44+15, w, h)];
    _busineImage.backgroundColor = [UIColor whiteColor];
    _busineImage.image = [UIImage imageNamed:@"home_busine"];
    _busineImage.userInteractionEnabled = YES;
    [_busineImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction3)]];
    [self.view addSubview:_busineImage];
    
    _healthImage = [[UIImageView alloc]initWithFrame:CGRectMake(w+30, h+44+15, w, h)];
    _healthImage.backgroundColor = [UIColor whiteColor];
    _healthImage.image = [UIImage imageNamed:@"home_health"];
    _healthImage.userInteractionEnabled = YES;
    [_healthImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction4)]];
    [self.view addSubview:_healthImage];
    
    _lineView= [[UIView alloc]initWithFrame:CGRectMake(15, 2*h+44+30, self.view.bounds.size.width-30, 60)];
    _lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_lineView];
    
    _storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 23, 60, 14)];
    _storeLabel.text = @"门店照片";
    _storeLabel.font = [UIFont systemFontOfSize:14];
    _storeLabel.textColor = [UIColor blackColor];
    [_lineView addSubview:_storeLabel];
    
    _logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-95, 5, 50, 50)];
    _logoImage.backgroundColor = [UIColor whiteColor];
    _logoImage.image = [UIImage imageNamed:@"home_store"];
    _logoImage.userInteractionEnabled = YES;
    [_logoImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction5)]];
    [_lineView addSubview:_logoImage];
    
    _applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 2*h+44+30+60+15, self.view.bounds.size.width-30, 36)];
    _applyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_applyBtn setTitle:@"完成申请" forState:UIControlStateNormal];
    [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_applyBtn setBackgroundColor:[UIColor colorWithHex:0xFD5B44]];
    _applyBtn.layer.cornerRadius = 3;
    [_applyBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_applyBtn];
    
}


-(void)sureAction{

    _hud = [AppUtil createHUD];
    _hud.labelText = @"正在上传...";
    _hud.userInteractionEnabled = NO;
    
    if(_image1 == NULL){
    
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请先上传身份证正面"];
        [_hud hide:YES afterDelay:2];
        
        return;
    
    }
    if(_image2 == NULL){
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请先上传身份证反面"];
        [_hud hide:YES afterDelay:2];
        
         return;
        
    }
    if(_image3 == NULL){
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请先上传营业执照"];
        [_hud hide:YES afterDelay:2];
        
         return;
        
    }
    if(_image4 == NULL){
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请先上传卫生许可证"];
        [_hud hide:YES afterDelay:2];
        
        return;
        
    }
    if(_image5 == NULL){
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = [NSString stringWithFormat:@"请先上传门店照片"];
        [_hud hide:YES afterDelay:2];
        
        return;
    }
    
    NSArray *nameArray = @[@"id_img_pros",@"id_img_cons",@"business_img",@"hygiene_img",@"store_img"];
    
    NSDictionary *params = @{@"store_id":self.store_id};
    
    [AFHttpTool uploadPictureWithURL:@"/store/auth/complete" nameArray:nameArray imagesArray:_imageArray params:params progress:^(NSProgress *progress) {
        
    } success:^(id response) {
    
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:5];
            
            return;
        }
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hud.labelText = @"温馨提示:";
        _hud.detailsLabelText = @"上传成功,请耐心等待审核,审核通过后将以短信方式通知您!";
        [_hud hide:YES afterDelay:4];
        
        [self performSelector:@selector(backAction) withObject:nil afterDelay:4.0f];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    

}

-(void)backAction{

    [self.navigationController popToRootViewControllerAnimated:YES];

}


-(void)pushAction1{
    
    self.imageInfo = @"image1";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
    
    [alertView show];

}

-(void)pushAction2{
    
    self.imageInfo = @"image2";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
    
    [alertView show];
    
}

-(void)pushAction3{
    
    self.imageInfo = @"image3";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
    
    [alertView show];
    
}

-(void)pushAction4{
    
    self.imageInfo = @"image4";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
    
    [alertView show];
    
    
}

-(void)pushAction5{
    
    
    self.imageInfo = @"image5";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];

    [alertView show];
    
}




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
                imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
                
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            
            
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = YES;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
}



#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [picker dismissViewControllerAnimated:YES completion:^ {
        
        if ([self.imageInfo isEqualToString:@"image1"]) {
            
            _image1 = info[UIImagePickerControllerEditedImage];
            
            _frontImage.image = _image1;
            
            [_imageArray replaceObjectAtIndex:0 withObject:_image1];
            
        }else if([self.imageInfo isEqualToString:@"image2"]){
            
            _image2 = info[UIImagePickerControllerEditedImage];
            
            _versoImage.image = _image2;
            
            [_imageArray replaceObjectAtIndex:1 withObject:_image2];
            
        }else if([self.imageInfo isEqualToString:@"image3"]){
            
            _image3 = info[UIImagePickerControllerEditedImage];
    
            _busineImage.image = _image3;
            
            [_imageArray replaceObjectAtIndex:2 withObject:_image3];
            
        }else if([self.imageInfo isEqualToString:@"image4"]){
            
            _image4 = info[UIImagePickerControllerEditedImage];
            
            _healthImage.image = _image4;
            
            [_imageArray replaceObjectAtIndex:3 withObject:_image4];
            
        }else if([self.imageInfo isEqualToString:@"image5"]){
            
            _image5 = info[UIImagePickerControllerEditedImage];
            
            _logoImage.image = _image5;
            
            [_imageArray replaceObjectAtIndex:4 withObject:_image5];
            
        }

    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
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
