//
//  Macros.h
//  FireShadow
//
//  Created by wangyebin on 15/9/23.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#ifndef FireShadow_Macros_h
#define FireShadow_Macros_h


#define trimString(str)         [[[str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]] componentsJoinedByString:@" "]

#define checkStrNull(str)       (str != nil && ![str isEqual:[NSNull null]] && ![trimString(str) isEqualToString:@" "])
/* 用户信息处理 */
#define checkNull(id)   (id != nil && ![id isEqual:[NSNull null]])





#define WIDTH  self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
//比例适配
#define ScaleWidth  1/375.0 * ScreenWidth
#define ScaleHeight 1/667.0 * ScreenHeight

#define RGBA(r, g, b, a)   [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)]
#define RGB(r, g, b)        RGBA(r, g, b, 1.0)
#define SeparateColor RGB(224,224,224)


#define OnePixelWidth  (ScreenWidth == 414 ? 0.334 : 0.5)


/* 字号大小处理 */
#define HelveticaNeueFont(fontSize)  [UIFont fontWithName:@"HelveticaNeue" size:(fontSize)]
#define HelveticaNeueLightFont(fontSize)    [UIFont fontWithName:@"HelveticaNeue-Light" size:(fontSize)]



// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//#define NSLog(fmt,...)

//个人日志输出
#define WYB
#ifdef WYB
#define WYBLog(fmt,...) NSLog( @"%s------------\n%@",__FUNCTION__, [NSString stringWithFormat:(fmt), ##__VA_ARGS__]);
#else
#define WYBLog(fmt,...)
#endif




//从Storyboard加载控制器
#define VCWithStoryboardNameAndVCIdentity(name,idetity) [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:idetity];
//从xib加载视图
#define ViewFromNibName(name) [[[NSBundle mainBundle] loadNibNamed:(name) owner:nil options:nil] firstObject]


//判断是否为ios7.0以前
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0 ? YES : NO)
//判断是否是ipone4
#define IsIphone4 ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)

//Device
#define kHigher_iOS_6_1 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define kHigher_iOS_6_1_DIS(_X_) ([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue] * _X_)
#define kNotHigher_iOS_6_1_DIS(_X_) (-([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue]-1) * _X_)

#define IOS7 [kCurrentDevice.systemVersion floatValue] >= 7.0 //iOS7
#define IOS8 [kCurrentDevice.systemVersion floatValue] >= 8.0 //iOS8

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] cur



#endif
