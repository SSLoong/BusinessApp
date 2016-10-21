//
//  RedListViewController.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/9/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "GoodsManageViewController.h"
#import "InventoryViewController.h"
#import "GoodsSellViewController.h"
#import "ScanAddViewController.h"
#import "SearchViewController.h"
#import "KxMenu.h"


@interface GoodsManageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UISegmentedControl *mySegmentCtrl;

@property (nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong)NSString * startTime;

@property(nonatomic,strong)NSString * endTime;

@end

@implementation GoodsManageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
 
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *array = @[@"市场",@"店铺"];
    
    
    _mySegmentCtrl = [[UISegmentedControl alloc] initWithItems:array];
    
   _mySegmentCtrl.frame = CGRectMake((ScreenWidth-160)/2, 7, 160, 30);
    
    _mySegmentCtrl.selectedSegmentIndex = 0;
    
    [_mySegmentCtrl addTarget:self action:@selector(clickSegmentCtrl:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _mySegmentCtrl;
    //[self.navigationItem setTitleView:_mySegmentCtrl];
    //[self.navigationController.navigationBar.topItem setTitleView:_mySegmentCtrl];
    
    [self createScrollView];
    
    if ([[DEFAULTS objectForKey:@"type"]integerValue] == 3) {
    }else{
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(listNoticeAction) name:@"ListNotice" object:nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)addAction{
    
    if (_mySegmentCtrl.selectedSegmentIndex == 0) {
         [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"市场商品请去货源市场采购" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
    }else{
        NSArray *menuItems = @[
                               [KxMenuItem menuItem:@"扫码添加"
                                              image:[UIImage imageNamed:@"add_scan"]
                                             target:self
                                             action:@selector(pushScan)],
                               
                               [KxMenuItem menuItem:@"手动添加"
                                              image:[UIImage imageNamed:@"add_hand"]
                                             target:self
                                             action:@selector(pushAdd)],
                               ];
        
        CGRect targetFrame = CGRectMake([AppUtil getScreenWidth]-45, 25, 40, 40);
        
        [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                      fromRect:targetFrame
                     menuItems:menuItems];
    }
    
}

-(void)pushScan{
    
    ScanAddViewController *vc = [[ScanAddViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)pushAdd{
    
    SearchViewController *vc = [[SearchViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)listNoticeAction{
    _mySegmentCtrl.selectedSegmentIndex = 1;
    
    [self clickSegmentCtrl:_mySegmentCtrl];
}

-(void)createScrollView{
        //市场界面

    for (int i=0 ; i<2 ;i++){
        
        GoodsSellViewController *ctrl = [[GoodsSellViewController alloc]init];
        if (i == 0) {
            ctrl.stocktype = 5;
        }else{
            ctrl.stocktype = 1;
        }
        [self addChildViewController:ctrl];
    }
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [AppUtil getScreenWidth],[AppUtil getScreenHeight]-64)];
    
    _scrollView.delegate = self;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat contentX = self.childViewControllers.count * _scrollView.bounds.size.width;
    
    _scrollView.contentSize = CGSizeMake(contentX, 0);
    
    [self.view addSubview:_scrollView];
    
    UITableViewController *vc = [self.childViewControllers firstObject];
    
    vc.view.frame = _scrollView.bounds;
    
    [_scrollView addSubview:vc.view];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    NSUInteger index = scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    _mySegmentCtrl.selectedSegmentIndex = index;
    
    GoodsSellViewController *newsVc = self.childViewControllers[index];
 
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    
    [_scrollView addSubview:newsVc.view];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}

- (void)clickSegmentCtrl:(UISegmentedControl *)mySegmentCtrl
{
    
    NSInteger num = mySegmentCtrl.selectedSegmentIndex;
    
    CGFloat offsetX = num * _scrollView.frame.size.width;
    
    CGFloat offsetY = _scrollView.contentOffset.y;
    
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_scrollView setContentOffset:offset animated:YES];
    
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
