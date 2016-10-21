//
//  NSString+WYBExtension.m
//  MyTool
//
//  Created by 久远的回忆 on 16/3/16.
//  Copyright © 2016年 wangyebin. All rights reserved.
//

#import "NSString+WYBExtension.h"

@implementation NSString (WYBExtension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    if (IsIOS7) {
        return [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByTruncatingTail];
    }else{
        
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
}

- (NSString *)usualTimeString
{
    
   return [self usualTimeStringWithDateFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)usualTimeStringWithDateFormatter:(NSString *)TimeStr
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeStr];
    NSDate * time = [dateFormatter dateFromString:self];
    NSDate * now = [NSDate date];
    NSString * nowStr = [dateFormatter stringFromDate:now];
    NSDate * date = [dateFormatter dateFromString:nowStr];
    
    
    NSTimeInterval second = [date timeIntervalSinceDate:time];
    
    if (second >= 0 && second <= 60) {
        return @"刚刚";
    }else if (second > 60 && second < 3600){
        return [NSString stringWithFormat:@"%d分钟前",(int)second/60];
    }else if (second >= 3600 && second < 86400){
        return [NSString stringWithFormat:@"%d小时前",(int)second/3600];
    }else if (second >= 86400 && second < 86400 * 2){
        return @"昨天";
    }else if (second >= 86400*2 && second < 86400 * 3){
        return @"前天";
    }else if (second >= 86400*3 && second < 86400 * 30){
        return [NSString stringWithFormat:@"%d天前",(int)second/86400];
    }else if (second >= 86400 *30 && second < 86400 * 365){
        return [NSString stringWithFormat:@"%d月前",(int)second/(86400 * 30)];
    }else{
        return [NSString stringWithFormat:@"%d年前",(int)second/(86400 * 365)];
    }

}

//如果字符串为nil则返回@"",否则返回原字符串
- (NSString *)checkTheStr
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    } else if (self == nil){
        return @"";
    } else if ([self isEqual:[NSNull null]]) {
        return @"";
    } else {
        return self;
    }
}


@end
