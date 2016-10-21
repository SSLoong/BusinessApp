//
//  RevisedPriceVC.h
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/12.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevisedPriceVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) IBOutlet UITextField *MoneyTextField;
@property (strong, nonatomic) IBOutlet UIButton *sure;

@property (strong, nonatomic) NSString *moneyStr;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *sg_id;
@property (strong, nonatomic) NSString *special_id;



@property(nonatomic,strong)NSMutableArray *generals;

@property(nonatomic,strong)NSMutableArray *specials;

@property(nonatomic,assign)NSInteger lastMoney;

@property(nonatomic,assign)NSInteger subMoney;

@property (nonatomic, assign) NSInteger type;


@property (nonatomic, copy) void(^changeBtnBlockOne)(NSMutableArray *generals,NSMutableArray *specials,NSInteger lastMoney,NSInteger subMoney,NSString *key,NSString *sg_id);

@property (nonatomic, copy) void(^changeBtnBlockTwo)(NSMutableArray *generals,NSMutableArray *specials,NSInteger lastMoney,NSInteger subMoney,NSString *key,NSString *sg_id);


@end
