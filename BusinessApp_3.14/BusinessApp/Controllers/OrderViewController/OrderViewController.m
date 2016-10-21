//
//  OrderViewController.m
//  BusinessApp
//
//  Created by prefect on 16/3/21.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderDataController.h"
#import "PerfectDate.h"
#import "DateView.h"


@interface OrderViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UISegmentedControl *mySegmentCtrl;

@property(nonatomic,strong)PerfectDate *dateMenu;

@property(nonatomic,strong)DateView *dateView;

@property(nonatomic,strong)UIScrollView *scrollView;



@end

@implementation OrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@"xx"
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
    
    
    NSArray *array = @[@"待处理",@"已完成"];
    
    _mySegmentCtrl = [[UISegmentedControl alloc] initWithItems:array];
    
    _mySegmentCtrl.frame = CGRectMake(([AppUtil getScreenWidth]-160)/2, 7, 160, 30);
    
    _mySegmentCtrl.selectedSegmentIndex = 0;
    
    [_mySegmentCtrl addTarget:self action:@selector(clickMySegmentCtrl:) forControlEvents:UIControlEventValueChanged];

    
    self.navigationItem.titleView = _mySegmentCtrl;

    [self createScrollView];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(noticeAction) name:@"orderNotice" object:nil];

}


-(void)noticeAction{

    _mySegmentCtrl.selectedSegmentIndex = 1;
    
    [self clickMySegmentCtrl:_mySegmentCtrl];
    
}


-(void)createScrollView{

    for (int i=0 ; i<2 ;i++){
        
        
        OrderDataController *ctrl = [[OrderDataController alloc]init];
        
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

#pragma mark - scrollView代理

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    NSUInteger index = scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    _mySegmentCtrl.selectedSegmentIndex = index;
    
    OrderDataController *newsVc = self.childViewControllers[index];

    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    
    [_scrollView addSubview:newsVc.view];
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}


- (void)clickMySegmentCtrl:(UISegmentedControl *)mySegmentCtrl
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
