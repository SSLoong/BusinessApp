//
//  BankListModel.h
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankListModel : NSObject

@property(nonatomic,copy)NSString *bank_card;

@property(nonatomic,copy,setter=setId:)NSString *sId;

@property(nonatomic,copy)NSString *is_default;

@property(nonatomic,copy)NSString *open_branch;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *bank_phone;


@end
