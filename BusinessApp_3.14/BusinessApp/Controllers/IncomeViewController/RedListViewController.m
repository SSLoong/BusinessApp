//
//  RedListViewController.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/9/27.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "RedListViewController.h"
#import "ListDataViewController.h"
#import "IncomeDetailController.h"
#import "DateSiftViewController.h"


@interface RedListViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UISegmentedControl *mySegmentCtrl;

@property (nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong)NSString * startTime;

@property(nonatomic,strong)NSString * endTime;

@end

@implementation RedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(IncomescreenBtn:)];
    self.navigationItem.rightBarButtonItem=releaseButon;

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *array = @[@"全部",@"订单",@"进货",@"奖励"];
    
    
    

    
    _mySegmentCtrl = [[UISegmentedControl alloc] initWithItems:array];
    
    if (kDevice_Is_iPhone5) {
        //self.navigationItem.hidesBackButton = YES;
        _mySegmentCtrl.frame = CGRectMake((ScreenWidth-160)/2, 7, 160, 25);
    }else{
    _mySegmentCtrl.frame = CGRectMake((ScreenWidth-240)/2, 7, 240, 30);
    }
    _mySegmentCtrl.selectedSegmentIndex = 0;
    
    [_mySegmentCtrl addTarget:self action:@selector(clickSegmentCtrl:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _mySegmentCtrl;
    //[self.navigationItem setTitleView:_mySegmentCtrl];
    //[self.navigationController.navigationBar.topItem setTitleView:_mySegmentCtrl];
    
    [self createScrollView];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(listNoticeAction) name:@"ListNotice" object:nil];

    
    // Do any additional setup after loading the view.
}

- (void)IncomescreenBtn:(UIButton *)btn{
    DateSiftViewController *vc = [[DateSiftViewController alloc]init];

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)listNoticeAction{
    _mySegmentCtrl.selectedSegmentIndex = 1;
    
    [self clickSegmentCtrl:_mySegmentCtrl];
}

-(void)createScrollView{
    
    for (int i=0 ; i<4 ;i++){
        
        IncomeDetailController *ctrl = [[IncomeDetailController alloc]init];
        ctrl.type = i;
        
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
    
    IncomeDetailController *newsVc = self.childViewControllers[index];
    DateSiftViewController *vc = [[DateSiftViewController alloc]init];
    vc.sureBtnBlock = ^(NSString *startTime,NSString *endTime){
        newsVc.startTime = startTime;
        newsVc.endTime = endTime;
        [newsVc.tbView.mj_header beginRefreshing];
    };

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
