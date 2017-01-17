//
//  StoreInfoController.m
//  BusinessApp
//
//  Created by prefect on 16/3/22.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreInfoController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AreaViewController.h"
#import "ChangeDataViewController.h"
#import "SettingViewController.h"
#import "ManagerController.h"




@interface StoreInfoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (weak, nonatomic) IBOutlet UILabel *dianpuLabel;

@property (weak, nonatomic) IBOutlet UILabel *gongsiLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *quyuLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *fuzerenLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (nonatomic, strong) UIImage *image;


@end

@implementation StoreInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"门店信息";
    
    [self loadData];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"areaChange" object:nil];
    
}





-(void)notice:(NSNotification *)not{
    
    
    self.quyuLabel.text = not.userInfo[@"area"];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)loadData{
    
    _hud = [AppUtil createHUD];
    
    [AFHttpTool getStoreInfo:Store_id
     
                    progress:^(NSProgress *progress) {
                        
                    } success:^(id response) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSDictionary *dic = response[@"data"][@"store"];
                            
                            [_logoImage sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"store_header"]];
                            _dianpuLabel.text = dic[@"name"];
                            _gongsiLabel.text = dic[@"company_name"];
                            _phoneLabel.text = dic[@"phone"];
                            _quyuLabel.text = [NSString stringWithFormat:@"%@ %@ %@", dic[@"province"], dic[@"city"], dic[@"area"]];
                            _addressLabel.text = dic[@"address"];
                            _fuzerenLabel.text = dic[@"contact"];
                            
                            NSInteger type =[dic[@"type"] integerValue];
                            
                            switch (type) {
                                case 0:
                                    _typeLabel.text = @"餐饮";
                                    break;
                                case 1:
                                    _typeLabel.text = @"门店";
                                    break;
                                case 2:
                                    _typeLabel.text = @"私营";
                                    break;
                                case 3:
                                    _typeLabel.text = @"连锁";
                                    break;
                                case 4:
                                    _typeLabel.text = @"专卖";
                                    break;
                                default:
                                    break;
                            }
                            
                            [_hud hide:YES];
                            [self.tableView reloadData];
                            
                            
                        });
                        
                        
                    } failure:^(NSError *err) {
                        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    BOOL isAdmin = [[NSUserDefaults standardUserDefaults]boolForKey:@"isAdmin"];
    
    if (isAdmin) {
        return 2;
    }else{
        return 1;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_typeLabel.text.length == 0) {
        
        return;
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片" message:nil delegate:self
                                                      cancelButtonTitle:@"取消" otherButtonTitles:@"相机", @"相册", nil];
            alertView.tag = 2;
            
            [alertView show];
            
        }else if(indexPath.row == 4){
            
            AreaViewController *vc = [[AreaViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1) {
            
            ChangeDataViewController *vc= [[ChangeDataViewController alloc]init];
            
            vc.newValue = ^(NSString *value){
                
                _dianpuLabel.text = value;
                
            };
            
            vc.titleString = @"店铺名称";
            
            vc.value = _dianpuLabel.text;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(indexPath.row == 3){
            
            ChangeDataViewController *vc= [[ChangeDataViewController alloc]init];
            
            vc.newValue = ^(NSString *value){
                
                _phoneLabel.text = value;
                
            };
            
            vc.titleString = @"联系电话";
            
            vc.value = _phoneLabel.text;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if(indexPath.row == 5){
            
            ChangeDataViewController *vc= [[ChangeDataViewController alloc]init];
            
            
            vc.newValue = ^(NSString *value){
                
                _addressLabel.text = value;
                
            };
            
            vc.titleString = @"详细地址";
            
            vc.value = _addressLabel.text;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else if(indexPath.row == 6){
            
            ChangeDataViewController *vc= [[ChangeDataViewController alloc]init];
            
            vc.newValue = ^(NSString *value){
                
                _fuzerenLabel.text = value;
                
            };
            
            vc.titleString = @"负责人";
            
            vc.value = _fuzerenLabel.text;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 8){
            
            ManagerController *vc = [[ManagerController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    
        
    }else{
        SettingViewController *vc = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)updatePortrait
{
    
    _hud = [AppUtil createHUD];
    
    _hud.userInteractionEnabled = YES;
    
    _hud.labelText = @"正在上传图片";
    
    NSArray *nameArray = @[@"store_img"];
    
    NSDictionary *params = @{@"store_id":Store_id};
    
    NSArray *imageArray = [NSArray arrayWithObject:_image];
    
    [AFHttpTool uploadPictureWithURL:@"/store/headimage/update" nameArray:nameArray imagesArray:imageArray params:params progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:5];
            
            return;
        }
        
        _logoImage.image = _image;
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


#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^ {
        [self updatePortrait];
    }];
}


@end
