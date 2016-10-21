//
//  ChangeDataViewController.h
//  MyTvGame
//
//  Created by perfect on 15/8/7.
//  Copyright (c) 2015年 prefect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^newValue)(NSString *value);


@interface ChangeDataViewController : UITableViewController

@property(nonatomic,copy)newValue newValue;

@property(nonatomic,strong)NSString *titleString;

@property(nonatomic,strong)NSString *value;

@end
