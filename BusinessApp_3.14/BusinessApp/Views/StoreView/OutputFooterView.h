//
//  OutputFooterView.h
//  BusinessApp
//
//  Created by wangyebin on 16/8/29.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutputFooterView : UIView

@property (nonatomic, copy) void (^changeBlock) (NSString * name,NSString * phone);
@property (nonatomic, copy) void (^buttonBlcok)();

@property (weak, nonatomic) IBOutlet UITextField *phoneTef;
@property (weak, nonatomic) IBOutlet UITextField *nameTef;

@end
