//
//  BankListTableViewCell.h
//  BusinessApp
//
//  Created by prefect on 16/3/14.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>
#import "BankListModel.h"

@interface BankListTableViewCell : MGSwipeTableCell

@property(nonatomic,strong)UILabel *bankNameLabel;

@property(nonatomic,strong)UILabel *typeLabel;

@property(nonatomic,strong)UILabel *cardLabel;

@property(nonatomic,strong)UILabel *defaultLabel;

-(void)configWithModel:(BankListModel *)model;

@end
