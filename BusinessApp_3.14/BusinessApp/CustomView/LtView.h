//
//  LtView.h
//  UI 第3讲练习
//
//  Created by lanou3g on 15/6/17.
//  Copyright (c) 2015年 wangyebin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LtView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (strong, nonatomic) UILabel * label;
@property (nonatomic, assign) float scale;//label所占的比例

- (instancetype)initWithFrame:(CGRect)frame lableText:(NSString *)text1 fieldText:(NSString *)text2;
@end
