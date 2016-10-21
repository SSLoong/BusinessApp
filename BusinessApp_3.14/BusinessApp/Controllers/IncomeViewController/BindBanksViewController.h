//
//  BindBanksViewController.h
//  BusinessApp
//
//  Created by prefect on 16/3/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^didSelectRow)(NSString *bankString,NSString *codeString);

@interface BindBanksViewController : UITableViewController

@property(nonatomic,copy)didSelectRow didSelectRows;

@property(nonatomic,copy)NSString *name;

@end
