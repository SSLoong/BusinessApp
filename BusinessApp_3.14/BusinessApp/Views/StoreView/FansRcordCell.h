//
//  FansRcordCell.h
//  BusinessApp
//
//  Created by wangyebin on 16/8/19.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FansRcordCell : UITableViewCell

@property (strong, nonatomic) NSDictionary * dic;
@property (nonatomic, copy) void (^buttonBlcok)();
@property (nonatomic, copy) void (^detailsBlcok)();

@end
