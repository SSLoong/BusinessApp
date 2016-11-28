//
//  FansRcordCell.h
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/18.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansRewardModel.h"
@interface FansRcordCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dic;

- (void)configDataModel:(FansRewardModel *)modle;

@end
