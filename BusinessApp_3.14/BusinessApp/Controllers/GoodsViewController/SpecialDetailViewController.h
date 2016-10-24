//
//  SpecialDetailViewController.h
//  BusinessApp
//
//  Created by AlexChang on 16/9/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface SpecialDetailViewController : UITableViewController

@property(nonatomic,strong)ActivityModel *model;

@property (nonatomic, strong) NSString *special_id;

@end
