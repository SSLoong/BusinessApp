//
//  AddGoodsViewController.h
//  BusinessApp
//
//  Created by prefect on 16/5/13.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^refreshView)();
@interface AddGoodsViewController : UIViewController

@property(nonatomic,copy)NSString *goods_id;

@property(nonatomic,copy)refreshView refreshView;

@end
