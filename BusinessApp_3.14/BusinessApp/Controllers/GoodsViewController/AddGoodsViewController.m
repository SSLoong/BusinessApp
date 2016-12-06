//
//  AddGoodsViewController.m
//  BusinessApp
//
//  Created by prefect on 16/5/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "AddGoodsViewController.h"
#import <SDCycleScrollView.h>

@interface AddGoodsViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic,copy)NSString *nameString;

@property(nonatomic,strong)NSArray *imageArray;

@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *purchase_price;

@property(nonatomic,copy)NSString *real_price;

@property(nonatomic,copy)NSString *stock;

@property(nonatomic,strong)UITextField *textFiled1;

@property(nonatomic,strong)UITextField *textFiled2;

@property(nonatomic,strong)UITextField *textFiled3;

@property(nonatomic,strong)UITextField *textFiled4;


@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"编辑商品";
    
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem=releaseButon;

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    [self loadData];

}

-(void)loadData{
    
    _hud = [AppUtil createHUD];
    
    _hud.labelText = @"加载中...";
    
    _hud.userInteractionEnabled = NO;
    
    [AFHttpTool GoodsInfo:Store_id
                 goods_id:_goods_id
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
        
        _imageArray = response[@"data"][@"img"];
        
        _nameString = response[@"data"][@"name"];
        
        _price = response[@"data"][@"price"];
        
        _purchase_price = response[@"data"][@"purchase_price"];
        
        _real_price = response[@"data"][@"real_price"];
        
        _stock = response[@"data"][@"stock"];
        
        [self initSubviews];
        
        [_hud hide:YES];
        
    } failure:^(NSError *err) {
        
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"Error";
        _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
        [_hud hide:YES afterDelay:2];
        
    }];
    
}


-(void)initSubviews{
    
    UIView *view0 = [UIView new];
    view0.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view0];
    
    _cycleScrollView = [SDCycleScrollView new];
    _cycleScrollView.currentPageDotColor = [UIColor colorWithHex:0xFD5B44];
    _cycleScrollView.pageDotColor = [UIColor colorWithHex:0xFFD2D2];
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"logo_place"];
    _cycleScrollView.imageURLStringsGroup = _imageArray;
    [view0 addSubview:_cycleScrollView];
 
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = _nameString;
    nameLabel.lineBreakMode = 2;
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    [view1 addSubview:nameLabel];
    
    
    UIImageView *goodsImageView = [UIImageView new];
    goodsImageView.image = [UIImage imageNamed:@"goods_detail"];
    [view1 addSubview:goodsImageView];
    
    
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"市场价:";
    label2.font = [UIFont systemFontOfSize:10];
    [view2 addSubview:label2];
    
    UILabel *mLabel2 = [UILabel new];
    mLabel2.text = @"¥";
    mLabel2.font = [UIFont systemFontOfSize:10];
    [view2 addSubview:mLabel2];
    
    _textFiled1 = [UITextField new];
    _textFiled1.keyboardType =  UIKeyboardTypeDecimalPad;
    _textFiled1.font = [UIFont systemFontOfSize:16];
    _textFiled1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled1.placeholder = @"请输入市场价";
    _textFiled1.text = _price;
    [view2 addSubview:_textFiled1];
    
    
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    
    UILabel *label3 = [UILabel new];
    label3.text = @"进货价:";
    label3.font = [UIFont systemFontOfSize:10];
    [view3 addSubview:label3];
    
    UILabel *mLabel3 = [UILabel new];
    mLabel3.text = @"¥";
    mLabel3.font = [UIFont systemFontOfSize:10];
    [view3 addSubview:mLabel3];
    
    _textFiled2 = [UITextField new];
    _textFiled2.keyboardType =  UIKeyboardTypeDecimalPad;
    _textFiled2.font = [UIFont systemFontOfSize:16];
    _textFiled2.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled2.placeholder = @"请输入进货价";
    _textFiled2.text = _purchase_price;
    _textFiled2.enabled = NO;
    [view3 addSubview:_textFiled2];
    
    

    UIView *view4 = [UIView new];
    view4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view4];
    
    UILabel *bLabel4 = [UILabel new];
    bLabel4.text = @"*";
    bLabel4.textColor = [UIColor redColor];
    bLabel4.font = [UIFont systemFontOfSize:10];
    [view4 addSubview:bLabel4];
    
    UILabel *label4 = [UILabel new];
    label4.text = @"售价:";
    label4.font = [UIFont systemFontOfSize:10];
    [view4 addSubview:label4];
    
    UILabel *mLabel4 = [UILabel new];
    mLabel4.text = @"¥";
    mLabel4.font = [UIFont systemFontOfSize:10];
    [view4 addSubview:mLabel4];
    
    _textFiled3 = [UITextField new];
    _textFiled3.keyboardType =  UIKeyboardTypeDecimalPad;
    _textFiled3.font = [UIFont systemFontOfSize:16];
    _textFiled3.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled3.placeholder = @"请输入销售价格";
    _textFiled3.text = _real_price;
    [view4 addSubview:_textFiled3];
    
    
    [view0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(69);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo([AppUtil getScreenHeight] *0.2f);
    }];
    
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([AppUtil getScreenHeight] *0.2f, [AppUtil getScreenHeight] *0.2f));
        make.centerX.equalTo(view0.mas_centerX);
    }];
    
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view0.mas_bottom).offset(5.f);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-73);
        make.centerY.equalTo(view1.mas_centerY);
    }];
    
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(58, 50));
    }];
    
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom).offset(5.f);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
    }];
    
    [mLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(28);
    }];
    
    [_textFiled1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(55);
    }];
    
    [_textFiled2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(55);
    }];
    
    [_textFiled3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(55);
    }];
    
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset(1.f);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
    }];
    
    [mLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(28);
    }];
    
    
    
    
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view3.mas_bottom).offset(1.f);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    [bLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
    }];
    
    
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
    }];
    
    [mLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(28);
    }];
    
}

-(void)addAction{

    _hud = [AppUtil createHUD];
    _hud.labelText = @"添加中...";
    _hud.userInteractionEnabled = NO;
    
    if(_textFiled1.text.length == 0){
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请输入市场价";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
    if(_textFiled2.text.length == 0){
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请输入进货价";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
    if(_textFiled3.text.length == 0){
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hud.labelText = @"请输入售价";
        [_hud hide:YES afterDelay:2];
        return;
    }
    
    [AFHttpTool GoodsAdd:Store_id
                goods_id:_dealer_goods_id
                mk_price:_textFiled1.text
                   price:_textFiled3.text
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

                     _hud.mode = MBProgressHUDModeCustomView;
                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                     _hud.labelText = @"添加成功";
                     [_hud hide:YES afterDelay:2];
                     if (self.refreshView) {
                         self.refreshView();
                     }
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 } failure:^(NSError *err) {
                     
                     _hud.mode = MBProgressHUDModeCustomView;
                     _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                     _hud.labelText = @"Error";
                     _hud.detailsLabelText = err.userInfo[NSLocalizedDescriptionKey];
                     [_hud hide:YES afterDelay:2];
                     
                 }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_hud hide:YES];

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
