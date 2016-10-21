//
//  BaseTableViewController.h
//  MVCtableView
//
//  Created by 久远的回忆 on 16/5/12.
//  Copyright © 2016年 wangyebin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"

@interface BaseTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView * tableView;
//@property (strong, nonatomic) NSMutableArray * sections;

@end
