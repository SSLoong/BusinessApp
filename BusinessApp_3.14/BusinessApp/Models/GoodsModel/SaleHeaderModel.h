//
//  SaleHeaderModel.h
//  BusinessApp
//
//  Created by prefect on 16/4/1.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleHeaderModel : NSObject

@property(nonatomic,copy)NSString *dealer_name;

@property(nonatomic,copy)NSString *company_address;

@property(nonatomic,copy)NSString *company_tel;

@property(nonatomic,copy)NSString *spetype;

@property(nonatomic,copy)NSString *strategy;

@property(nonatomic,copy)NSString *time;

@property(nonatomic,copy)NSString *nowstatus;

@property (nonatomic,copy) NSString *nowtime;

@property(nonatomic,copy)NSString *special_id;

@property(nonatomic,strong)NSArray *awardlist;

@property(nonatomic,copy)NSString *awardresult;

@end
