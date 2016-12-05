//
//  ShellListCell.h
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/25.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsStateModel.h"
@interface ShellListCell : UITableViewCell

@property (nonatomic, copy) void(^PushTapBlock)();

- (void)configDataModel:(GoodsStateModel *)model;


@end
