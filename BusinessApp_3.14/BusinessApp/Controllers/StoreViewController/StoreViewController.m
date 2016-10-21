//
//  StoreViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "StoreViewController.h"
#import <UIImageView+WebCache.h>
#import "NoticeTableViewController.h"
#import "SettingViewController.h"
#import "StoreInfoController.h"
#import "OpenKicketViewController.h"
#import "DeliverRangesController.h"
#import "MinMoneyController.h"

#import "CartViewController.h"
#import "UMSocial.h"
#import "StoreCodeViewController.h"
#import "FansRecordVC.h"
#import "OutputVC.h"
#import "AddGoodSTwoVC.h"
#import "ScanAddViewController.h"

#import "SourceViewController.h"
#import "InventoryViewController.h"
#import "GoodsSellViewController.h"
#import "ActivityViewController.h"
#import "SourceListViewController.h"
#import "GoodsSetViewController.h"
#import "OrderViewController.h"
#import "ActivitySpecialController.h"
#import "GoodsManageViewController.h"

NSString * const kInvite_code = @"invite_code";//邀请码
NSString * const kMessages = @"messages";//消息数
NSString * const kImg = @"img";//店铺图片
NSString * const kName = @"name";//门店名字
NSString * const kLevel = @"level";//门店等级
NSString * const kAddress = @"address";//门店地址
NSString * const kStatus = @"status";//门店状态
NSString * const kReceipt = @"receipt";//发票服务
NSString * const kDeliver = @"deliver";//配送服务


NSString * const kFans = @"fans";//粉丝数
NSString * const kSendcoupon = @"sendcoupon";//发送优惠券
NSString * const kUsecoupon = @"usecoupon";//使用优惠券

NSString * const ktype = @"type";//商铺类型



@interface StoreViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;
/**
 *  系统消息label
 */
@property (weak, nonatomic) IBOutlet UILabel *messaheLab;

@property (strong, nonatomic)  UIImageView *starImage;//星星图案

@property (strong, nonatomic) UIImageView *headerImage;//头像

@property (strong, nonatomic) UILabel *nameLabel;//店名

@property (weak, nonatomic) IBOutlet UISwitch *peisongSwitch;//配送选择

@property (weak, nonatomic) IBOutlet UISwitch *yingyeSwitch;//营业状态选择

@property(nonatomic,strong)UILabel *noticeLabel;

@property(nonatomic,strong)UIImageView *notImage;

@property(nonatomic,copy)NSString *titleString;

@property(nonatomic,copy)NSString *connt;

@property(nonatomic,copy)NSString *url;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UIView *activityView;
@property (strong, nonatomic) IBOutlet UIView *orderView;
@property (strong, nonatomic) IBOutlet UILabel *specialLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderLabel;

@end

@implementation StoreViewController

-(id)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick beginLogPageView:@"StoreView"];
    self.tableView.sectionHeaderHeight = 15;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    
    if (kDevice_Is_iPhone5) {
        self.tableView.allowsSelection = YES;
    }else{
        self.tableView.allowsSelection = NO;
    }
    
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 24, 24);
    [setBtn setImage:[UIImage imageNamed:@"store_set"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.headerImage = [[UIImageView alloc]init];
    self.nameLabel = [[UILabel alloc]init];
    
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    //UIBarButtonItem *noticeItem = [[UIBarButtonItem alloc] initWithCustomView:noticeImage];
    self.navigationItem.rightBarButtonItem = setItem;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([DEFAULTS objectForKey:kReceipt]) {
        
        [self upData];
    }
    
    [self loadData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"StoreView"];
}

-(void)loadData{
    
    [AFHttpTool getStoreInfo:[DEFAULTS objectForKey:@"store_id"]
     
                    progress:^(NSProgress *progress) {
                        
                    } success:^(id response) {
                        
                        if (!([response[@"code"]integerValue]==0000)) {
                            
                            _hud = [AppUtil createHUD];
                            NSString *errorMessage = response [@"msg"];
                            _hud.mode = MBProgressHUDModeCustomView;
                            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
                            [_hud hide:YES afterDelay:3];
                            
                            return;
                        }
                        
                        NSDictionary *dataDic = response[@"data"];
                        NSString *  message = [NSString stringWithFormat:@"您有%@条未读消息",dataDic[@"messages"]];
                        NSMutableAttributedString * Mstr = [Tool addColorWithString:message atRange:NSMakeRange(2, message.length - 7) withColor:[UIColor redColor]];
                        self.messaheLab.attributedText = Mstr;
                        
                        self.messageNum = [dataDic[@"messages"] intValue];
                        self.specialNum = [dataDic[@"specialnum"] intValue];
                        self.orderNum =   [dataDic[@"ordermessages"][@"shipmentnum"] intValue];
                        
                        if (self.messageNum + self.specialNum + self.orderNum == 0) {
                            //三个全有
                        }else if (self.messageNum > 0 && self.specialNum > 0 && self.orderNum >0){
                            NSString *  message = [NSString stringWithFormat:@"您有%@条未读消息",dataDic[@"messages"]];
                            NSMutableAttributedString * Mstr = [Tool addColorWithString:message atRange:NSMakeRange(2, message.length - 7) withColor:[UIColor redColor]];
                            self.messaheLab.attributedText = Mstr;
                            
                            NSString *specila = [NSString stringWithFormat:@"您有%@活动专场可参与",dataDic[@"specialnum"]];
                            NSMutableAttributedString * Spestr = [Tool addColorWithString:specila atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.specialLabel.attributedText = Spestr;
                            
                            NSString *order = [NSString stringWithFormat:@"您有%@笔新订单待处理",dataDic[@"ordermessages"][@"shipmentnum"]];
                            NSMutableAttributedString * Orderstr = [Tool addColorWithString:order atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.orderLabel.attributedText = Orderstr;
 
                            //未读消息
                        }else if (self.messageNum > 0 && self.specialNum == 0 && self.orderNum ==0){
                            NSString *  message = [NSString stringWithFormat:@"您有%@条未读消息",dataDic[@"messages"]];
                            NSMutableAttributedString * Mstr = [Tool addColorWithString:message atRange:NSMakeRange(2, message.length - 7) withColor:[UIColor redColor]];
                            self.messaheLab.attributedText = Mstr;
                            //活动专场
                        }else if (self.messageNum == 0 && self.specialNum > 0 && self.orderNum ==0){
                            NSString *  message = [NSString stringWithFormat:@"您有%@活动专场可参与",dataDic[@"specialnum"]];
                            NSMutableAttributedString * Mstr = [Tool addColorWithString:message atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.messaheLab.attributedText = Mstr;
                            //订单处理
                        }else if (self.messageNum == 0 && self.specialNum == 0 && self.orderNum >0){
                            NSString *  message = [NSString stringWithFormat:@"您有%@笔新订单待处理",dataDic[@"ordermessages"][@"shipmentnum"]];
                            NSMutableAttributedString * Mstr = [Tool addColorWithString:message atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.messaheLab.attributedText = Mstr;
                            //未读消息和活动专场
                        }else if (self.messageNum > 0 && self.specialNum > 0 && self.orderNum ==0){
                            NSString *  message = [NSString stringWithFormat:@"您有%@条未读消息",dataDic[@"messages"]];
                            NSMutableAttributedString * Mstr = [Tool addColorWithString:message atRange:NSMakeRange(2, message.length - 7) withColor:[UIColor redColor]];
                            self.messaheLab.attributedText = Mstr;
                            
                            NSString *specila = [NSString stringWithFormat:@"您有%@活动专场可参与",dataDic[@"specialnum"]];
                            NSMutableAttributedString * Spestr = [Tool addColorWithString:specila atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.specialLabel.attributedText = Spestr;
                            //未读消息和订单处理
                        }else if (self.messageNum > 0 && self.specialNum == 0 && self.orderNum >0){
                            NSString *  message = [NSString stringWithFormat:@"您有%@条未读消息",dataDic[@"messages"]];
                            NSMutableAttributedString * Mstr = [Tool addColorWithString:message atRange:NSMakeRange(2, message.length - 7) withColor:[UIColor redColor]];
                            self.messaheLab.attributedText = Mstr;
                            
                            NSString *order = [NSString stringWithFormat:@"您有%@笔新订单待处理",dataDic[@"ordermessages"][@"shipmentnum"]];
                            NSMutableAttributedString * Orderstr = [Tool addColorWithString:order atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.orderLabel.attributedText = Orderstr;
                            //活动专场和订单处理
                        }else if (self.messageNum == 0 && self.specialNum > 0 && self.orderNum >0){
                            NSString *specila = [NSString stringWithFormat:@"您有%@活动专场可参与",dataDic[@"specialnum"]];
                            NSMutableAttributedString * Spestr = [Tool addColorWithString:specila atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.specialLabel.attributedText = Spestr;
                            
                            NSString *order = [NSString stringWithFormat:@"您有%@笔新订单待处理",dataDic[@"ordermessages"][@"shipmentnum"]];
                            NSMutableAttributedString * Orderstr = [Tool addColorWithString:order atRange:NSMakeRange(2, message.length - 9) withColor:[UIColor redColor]];
                            self.orderLabel.attributedText = Orderstr;

                        }

                        
                        
                        NSDictionary *couponandfans = response[@"data"][@"couponandfans"];
                        WYBLog(@"返回数据:%@",response);
                        
                        NSDictionary *storeDic = response[@"data"][@"store"];
                        [DEFAULTS setObject:storeDic[@"invite_code"] forKey:kInvite_code];
                        [DEFAULTS setObject:storeDic[@"messages"] forKey:kMessages];
                        [DEFAULTS setObject:storeDic[@"img"] forKey:kImg];
                        [DEFAULTS setObject:storeDic[@"name"] forKey:kName];
                        [DEFAULTS setObject:storeDic[@"level"] forKey:kLevel];
                        [DEFAULTS setObject:storeDic[@"address"] forKey:kAddress];
                        [DEFAULTS setObject:storeDic[@"type"] forKey:ktype];

                        [DEFAULTS setObject:[NSString stringWithFormat:@"%@",storeDic[@"status"]] forKey:kStatus];
                        [DEFAULTS setObject:storeDic[@"receipt"] forKey:kReceipt];
                        [DEFAULTS setObject:storeDic[@"deliver"] forKey:kDeliver];
                        [DEFAULTS setObject:dataDic[@"messages"] forKey:kMessages];
                        
                        [DEFAULTS setObject:couponandfans[@"fans"] forKey:kFans];
                        [DEFAULTS setObject:couponandfans[@"sendcoupon"] forKey:kSendcoupon];
                        [DEFAULTS setObject:couponandfans[@"usecoupon"] forKey:kUsecoupon];
                        
                        
                        [DEFAULTS synchronize];
                        [_hud hide:YES];
                        
                        
                        if ([[DEFAULTS objectForKey:ktype]integerValue] == 3) {
                            self.sourceView.hidden = YES;
                            self.listView.hidden = YES;
                            self.otherView.hidden = YES;
                        }else{
                            self.sourceView.hidden = NO;
                            self.listView.hidden = NO;
                            self.otherView.hidden = NO;
                        }
                        
                        
                        [self upData];
                        
                    } failure:^(NSError *err) {
                        
                        _hud = [AppUtil createHUD];
                        _hud.mode = MBProgressHUDModeCustomView;
                        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                        _hud.labelText = @"Error";
                        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                        [_hud hide:YES afterDelay:3];
                        
                    }];
    
    
}

-(void)upData{
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[DEFAULTS objectForKey:kImg]] placeholderImage:[UIImage imageNamed:@"store_header"]];
    _nameLabel.text = [DEFAULTS objectForKey:kName];
    self.navigationItem.title = [DEFAULTS objectForKey:kName];
       if ([[DEFAULTS objectForKey:kStatus]integerValue] == 0) {
        
        _yingyeSwitch.on = NO;
        
    }else{
        _yingyeSwitch.on = YES;
    }
    
    if ([[DEFAULTS objectForKey:kDeliver]integerValue] == 0) {
        
        _peisongSwitch.on = NO;
        
    }else{
        _peisongSwitch.on = YES;
    }
    
    if ([[DEFAULTS objectForKey:kMessages]integerValue] == 0) {
        
        _notImage.hidden = YES;
        
        
    }else{
        
        _notImage.hidden = NO;
        
    }
    
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.messageNum + self.specialNum + self.orderNum == 0) {
            return 85;
        }else if (self.messageNum > 0 && self.specialNum > 0 && self.orderNum >0){
            return 250;
        }else if (self.messageNum > 0 && self.specialNum == 0 && self.orderNum ==0){
            return 140;
        }else if (self.messageNum == 0 && self.specialNum > 0 && self.orderNum ==0){
            return 140;
        }else if (self.messageNum == 0 && self.specialNum == 0 && self.orderNum >0){
            return 140;
        }else
            return 195;
    }else if (indexPath.section == 1){
        return 41;
    }else
        return 191;

}

//设置按钮响应事件
-(void)setAction{
    
    //SettingViewController *vc = [[SettingViewController alloc]init];
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StoreInfo" bundle:nil];
    
    StoreInfoController *vc= [storyboard instantiateViewControllerWithIdentifier:@"StoreInfo"];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


-(void)downloadImage:(NSString *)urlString{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:urlString]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            
                            if (finished) {
                                
                                if (image) {
                                    
                                    [self shareMyStore:image];
                                    [_hud hide:YES];
                                    
                                }else{
                                    
                                    [self shareMyStore:[UIImage imageNamed:@"icon"]];
                                    [_hud hide:YES];
                                    
                                }
                                
                            }
                            
                        }];
    
}


//我的订单
- (IBAction)manageFans:(id)sender {
    
    OrderViewController *vc = [[OrderViewController alloc]init];
    
    vc .hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}
//客户管理
- (IBAction)shareStore:(id)sender {
    
    
    FansRecordVC * vc = VCWithStoryboardNameAndVCIdentity(@"StoreInfo", @"FansRecordVC");
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

    
    
}
//店铺推广
- (IBAction)invoiceSetting:(id)sender {
    
    _hud = [AppUtil createHUD];
    
    [AFHttpTool appShare:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:5];
            
            return;
        }
        
        _titleString = response[@"data"][@"title"];
        _url = response[@"data"][@"url"];
        _connt = response[@"data"][@"connt"];
        [self downloadImage:response[@"data"][@"img"]];
        
    } failure:^(NSError *err) {
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
    }];
}

//营销设置
- (IBAction)deliverySetting:(id)sender {
    
    GoodsSetViewController *vc = [[GoodsSetViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}

//商品管理
- (IBAction)storeInfo:(id)sender {
    
        GoodsManageViewController *vc =[[GoodsManageViewController alloc]init];

        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  开票设置
 *
 *  @param sender
 */
- (IBAction)setMarketingAction:(id)sender {
    
    OpenKicketViewController *vc= [[OpenKicketViewController alloc]init];
    
    vc.index = [[DEFAULTS objectForKey:kReceipt] integerValue];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}

/**
 *  配送设置
 *
 *  @param sender
 */
- (IBAction)inventoryManagementAction:(id)sender {
    
    DeliverRangesController *vc= [[DeliverRangesController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


//未读消息
- (IBAction)message:(id)sender {
    
    if (self.messageNum == 0 && self.specialNum > 0 && self.orderNum ==0){
        
        self.tabBarController.selectedIndex = 1;
        
    }else if (self.messageNum == 0 && self.specialNum == 0 && self.orderNum >0){
        OrderViewController *vc = [[OrderViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        NoticeTableViewController *vc = [[NoticeTableViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        //活动专场
    }
}
//特卖活动消息
- (IBAction)special:(id)sender {
    //未读消息和订单处理
    if (self.messageNum > 0 && self.specialNum == 0 && self.orderNum >0){
        
        OrderViewController *vc = [[OrderViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (self.messageNum == 0 && self.specialNum > 0 && self.orderNum >0){
        
        OrderViewController *vc = [[OrderViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.messageNum > 0 && self.specialNum > 0 && self.orderNum ==0){
        
        self.tabBarController.selectedIndex = 1;

    }


}

//订单处理消息
- (IBAction)order:(id)sender {
    OrderViewController *vc = [[OrderViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  出库扫描
 *
 *  @param sender
 */
- (IBAction)outbounScanningAction:(id)sender {
    ScanAddViewController * VC = [[ScanAddViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.isPlural = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


//店铺码
- (IBAction)storeQcode:(id)sender {
    
    StoreCodeViewController *vc = [[StoreCodeViewController alloc]init];
    
    vc.logoImage = _headerImage.image;
    
    vc.nameString  = _nameLabel.text;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}
//生成订单

- (IBAction)productOrder:(id)sender {
    CartViewController *vc= [[CartViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}

/**
 *  资源市场
 *
 *  @param sender
 */
- (IBAction)resourceMarketAction:(id)sender {
    SourceViewController *vc = [[SourceViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}
/**
 *  货源清单
 *
 *  @param sender
 */
- (IBAction)sourceListAction:(id)sender {
    SourceListViewController *vc = [[SourceListViewController alloc]init];
    
    vc .hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
/**
 *  点击获取更多资讯
 *
 *  @param sender
 */
- (IBAction)getMoreAction:(id)sender {
}

-(void)shareMyStore:(UIImage *)image{
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppKey
                                      shareText:_connt
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:nil];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
    [UMSocialData defaultData].extConfig.qqData.url = _url;
    [UMSocialData defaultData].extConfig.qzoneData.url = _url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = _titleString;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _titleString;
    [UMSocialData defaultData].extConfig.qqData.title = _titleString;
    [UMSocialData defaultData].extConfig.qzoneData.title = _titleString;
}

//营业状态选择
- (IBAction)yingyeAction:(id)sender {
    
    
    _hud = [AppUtil createHUD];
    
    _hud.labelText = @"修改中";
    
    [AFHttpTool chanegStoreStatus:Store_id status:self.yingyeSwitch.on ? @"1":@"0" progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            if (self.yingyeSwitch.on) {
                
                self.yingyeSwitch.on = NO;
            }else{
                self.yingyeSwitch.on = YES;
            }
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        
        [DEFAULTS setObject:self.yingyeSwitch.on ? @1:@0  forKey:kStatus];
        
        
        [_hud hide:YES];
        
    } failure:^(NSError *err) {
        
        if (self.yingyeSwitch.on) {
            
            self.yingyeSwitch.on = NO;
        }else{
            self.yingyeSwitch.on = YES;
        }
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
    
    
}


//配送服务选择
- (IBAction)peisongAction:(id)sender {
    
    _hud = [AppUtil createHUD];
    _hud.labelText = @"修改中";
    
    [AFHttpTool chanegStoreDeliver:Store_id progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        
        
        if (!([response[@"code"]integerValue]==0000)) {
            
            
            if (self.peisongSwitch.on) {
                
                self.peisongSwitch.on = NO;
            }else{
                self.peisongSwitch.on = YES;
            }
            
            NSString *errorMessage = response [@"msg"];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误:%@", errorMessage];
            [_hud hide:YES afterDelay:3];
            
            return;
        }
        
        [DEFAULTS setObject:self.peisongSwitch.on ? @1:@0  forKey:kStatus];
        
        if(self.peisongSwitch.on){
            
            DeliverRangesController *vc= [[DeliverRangesController alloc]init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        [_hud hide:YES];
        
    } failure:^(NSError *err) {
        
        if (self.peisongSwitch.on) {
            
            self.peisongSwitch.on = NO;
        }else{
            self.peisongSwitch.on = YES;
        }
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:3];
        
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    WYBLog(@"dsf");
//    if (scrollView.contentOffset.y < 0.1) {
//        scrollView.contentOffset = CGPointMake(0, 0);
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
