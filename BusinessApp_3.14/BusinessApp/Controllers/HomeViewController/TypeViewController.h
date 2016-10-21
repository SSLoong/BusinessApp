//
//  TypeViewController.h
//  BusinessApp
//
//  Created by prefect on 16/3/4.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^chooseType)(NSString * typeString);

@interface TypeViewController : UITableViewController

@property(nonatomic,copy)chooseType chooseType;

@property(nonatomic,copy)NSString *cityCode;

@end
