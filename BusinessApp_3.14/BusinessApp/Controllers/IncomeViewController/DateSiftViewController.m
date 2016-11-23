//
//  DateSiftViewController.m
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "DateSiftViewController.h"
#import "InventoryListController.h"
#import "IncomeDetailController.h"
#import "DateSiftCell.h"

#import "ActionSheetDatePicker.h"
#import "NSDate+Helper.h"
#import "NSDate+Common.h"
@interface DateSiftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) DateSiftCell *cell;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;
@end

@implementation DateSiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日期查询";
    _start_time = [AppUtil getStartTime];
    
    _end_time = [AppUtil getEndTime];
    [self creatMyTableView];
    // Do any additional setup after loading the view.
}

- (void)creatMyTableView{
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[DateSiftCell class] forCellReuseIdentifier:kCellIdentifier_DateSiftCell];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });


}

#pragma mark -
#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_DateSiftCell forIndexPath:indexPath];
    self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        self.cell.titleLabel.text = @"开始时间";
        NSString *start = [_start_time substringToIndex:11];
        self.cell.timeLabel.text = start;
    }else{
        self.cell.titleLabel.text = @"截止时间";
        NSString *end = [_end_time substringToIndex:11];
        self.cell.timeLabel.text = end;
    }
    
    return self.cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath  animated:YES];
    
    
    if (indexPath.row == 0) {
        NSDate *curDate = [NSDate dateFromString:_start_time withFormat:@"yyyy-MM-dd HH:mm"];
        if (!curDate) {
            curDate = [NSDate date];
        }

        __weak typeof(self) weakSelf = self;
        ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            weakSelf.start_time = [(NSDate *)selectedDate string_yyyy_MM_dd_HH_mm];
            [weakSelf.myTableView reloadData];
            self.cell.timeLabel.text = weakSelf.start_time;
            
        } cancelBlock:nil origin:self.view];
        
        [picker addCustomButtonWithTitle:@"今天" value:[NSDate date]];
        [picker setHideCancel:YES];
        [picker setMaximumDate:[NSDate date]];
        picker.tapDismissAction = TapActionCancel;
        [picker showActionSheetPicker];
    }else if (indexPath.row == 1) {
        NSDate *curDate = [NSDate dateFromString:_end_time withFormat:@"yyyy-MM-dd HH:mm"];
        if (!curDate) {
            curDate = [NSDate date];
        }
        
        __weak typeof(self) weakSelf = self;
        ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            weakSelf.end_time = [NSString stringWithFormat:@"%@23:59",[[(NSDate *)selectedDate string_yyyy_MM_dd_HH_mm] substringToIndex:11]];

            [weakSelf.myTableView reloadData];
            self.cell.timeLabel.text = weakSelf.end_time;
            
        } cancelBlock:nil origin:self.view];
        
        [picker addCustomButtonWithTitle:@"今天" value:[NSDate date]];
        [picker setHideCancel:YES];
        [picker setMaximumDate:[NSDate date]];
        [picker setMinimumDate:[NSDate dateFromString:_start_time withFormat:@"yyyy-MM-dd"]];
        picker.tapDismissAction = TapActionCancel;
        [picker showActionSheetPicker];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    
    footView.backgroundColor = [UIColor clearColor];
    
    
    
    UIButton *sureButton  = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, ScreenWidth-40, 35)];
    
    sureButton.backgroundColor = [UIColor redColor];

    sureButton.layer.masksToBounds = YES;

    sureButton.layer.cornerRadius = 15.0f;
    
    [sureButton setTitle:@"查 询" forState:UIControlStateNormal];
    
    [sureButton addTarget:self action:@selector(sureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    sureButton.titleLabel.textColor = [UIColor grayColor];
    
    sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [footView addSubview:sureButton];
    
    
    
    return footView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 100;
}

- (void)sureButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];

//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.start_time,@"startTime",self.end_time,@"endTime", nil];
//    
//    //创建通知
//    
//    NSNotification *notification =[NSNotification notificationWithName:@"DataSiftNotification" object:nil userInfo:dict];
//    
//    //通过通知中心发送通知
//    
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
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
