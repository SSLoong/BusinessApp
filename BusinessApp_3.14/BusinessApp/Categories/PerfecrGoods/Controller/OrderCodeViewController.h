//
//  OrderCodeViewController.h
//  BusinessApp
//
//  Created by prefect on 16/4/22.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCodeViewController : UIViewController

@property(nonatomic,copy)NSString *key;

@property (nonatomic, copy) NSString *sg_id;

@property(nonatomic,strong)NSMutableArray *generals;

@property(nonatomic,strong)NSArray *specials;

@property(nonatomic,copy)NSString *money;

@property(nonatomic,copy)NSString *subMoney;

@property (nonatomic, strong) NSMutableArray *sgArr;


@end
