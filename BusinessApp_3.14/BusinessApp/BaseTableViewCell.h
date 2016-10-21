//
//  BaseTableViewCell.h
//  MVCtableView
//
//  Created by wangyebin on 16/5/13.
//  Copyright © 2016年 wangyebin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseTableViewCell : UITableViewCell


@property (strong, nonatomic) NSIndexPath * indexPath;

- (void)setTheDelegate:(id)delegate;


@end
