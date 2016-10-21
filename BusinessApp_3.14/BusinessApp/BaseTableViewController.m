//
//  BaseTableViewController.m
//  MVCtableView
//
//  Created by 久远的回忆 on 16/5/12.
//  Copyright © 2016年 wangyebin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableView.h"
#import "BaseTableViewCell.h"

@interface BaseTableViewController ()



@end

@implementation BaseTableViewController

//子类一定要要调用父类的viewDidLoad方法
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.sections = [[NSMutableArray alloc]initWithCapacity:5];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    
   
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   //Class a = NSClassFromString(@"");
    
    

   NSString * class = [self tableView:tableView cellClassForRowAtIndexPath:indexPath];
   BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:class forIndexPath:indexPath];
   [cell setTheDelegate:self];
    //SectionModel * section = self.sections[indexPath.section];
    //ItemModel * item = section.itemsArray[indexPath.row];
    //cell.itemModel = item;
    cell.indexPath = indexPath;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SectionModel * section = self.sections[indexPath.section];
//    ItemModel * item = section.itemsArray[indexPath.row] ;
    return 44;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (NSString *)tableView:(UITableView *)tableView cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSStringFromClass([BaseTableViewCell class]);
    
}

@end
