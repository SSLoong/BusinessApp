//
//  DateSiftCell.h
//  BusinessApp
//
//  Created by 孙升隆 on 16/10/10.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_DateSiftCell    @"DateSiftCellIdentifier"

@interface DateSiftCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

+(CGFloat)cellHeight;

@end
