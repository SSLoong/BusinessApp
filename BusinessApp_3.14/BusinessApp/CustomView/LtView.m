//
//  LtView.m
//  UI 第3讲练习
//
//  Created by lanou3g on 15/6/17.
//  Copyright (c) 2015年 wangyebin. All rights reserved.
//
//自定义LTView类 一个视图上有一个lable 和 一个textField
#import "LtView.h"
// 距离上边界
#define kTopPadding 0
// 距离左边界
#define kLeftPadding 0
// 控件之间的间隔
#define kPadding 0
// 距离下边界
#define kBottomPadding 0
//距离右边界
#define kRightPadding 0


@implementation LtView

- (void)dealloc{
}





// 之所以要重写initWithFrame:方法是因为父类的方法不能满足我的需求,我们的需求是在创建LTView的时候,创建一个label,创建一个textField
- (instancetype)initWithFrame:(CGRect)frame lableText:(NSString *)text1 fieldText:(NSString *)text2
{
    // 第一步先调用父类的方法
    self = [super initWithFrame:frame];
    if (self) {//然后添加lable 和 textfield;
        _label = [[UILabel alloc]initWithFrame:CGRectMake(kLeftPadding, kTopPadding, (frame.size.width - (kPadding+kLeftPadding+kRightPadding)) * _scale, frame.size.height - (kTopPadding + kBottomPadding))];
        _label.text = text1;
        _label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_label];
       
        
        CGFloat textFieldX = kPadding +kLeftPadding + _label.frame.size.width;
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, kTopPadding, (frame.size.width - (kPadding+kLeftPadding+kRightPadding)) * (1 - _scale), frame.size.height - (kTopPadding + kBottomPadding))];
        
        _textField.placeholder = text2;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textField];
        
        
    }
    
    return self;
    
}
@end
