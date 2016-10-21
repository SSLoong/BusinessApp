//
//  StoreViewController.h
//  BusinessApp
//
//  Created by prefect on 16/3/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UITableViewController


@property (strong, nonatomic) IBOutlet UIView *listView;

@property (strong, nonatomic) IBOutlet UIView *otherView;

@property (strong, nonatomic) IBOutlet UIView *sourceView;

@property (assign, nonatomic) int messageNum;

@property (assign, nonatomic) int specialNum;

@property (assign, nonatomic) int orderNum;


@end
