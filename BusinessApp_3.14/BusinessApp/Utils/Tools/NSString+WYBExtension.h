//
//  NSString+WYBExtension.h
//  MyTool
//
//  Created by 久远的回忆 on 16/3/16.
//  Copyright © 2016年 wangyebin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (WYBExtension)

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 *  把时间字符串转换成几天前,刚刚...这样的模式
 *
 *  @param TimeStr 时间字符串的格式
 *
 *  @return 几天前,刚刚...
 */
- (NSString *)usualTimeStringWithDateFormatter:(NSString *)TimeStr;
//把时间字符串转换成几天前,刚刚...这样的模式
- (NSString *)usualTimeString;

//如果字符串为nil则返回@"",否则返回原字符串
- (NSString *)checkTheStr;


@end
