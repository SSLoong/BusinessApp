//
//  UIButton+Extension.m
//  WhiteSharkBusiness
//
//  Created by 久远的回忆 on 15/12/14.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name;

@end