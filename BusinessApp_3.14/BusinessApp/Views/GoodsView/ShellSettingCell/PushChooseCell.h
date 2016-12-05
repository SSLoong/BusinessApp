//
//  PushChooseCell.h
//  BusinessApp
//
//  Created by 孙升隆 on 2016/11/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushChooseModel.h"


@interface PushChooseCell : UITableViewCell
{
            BOOL    m_checked;
}

@property (nonatomic, strong) PushChooseModel *model;

- (void)setChecked:(BOOL)checked;


@end
