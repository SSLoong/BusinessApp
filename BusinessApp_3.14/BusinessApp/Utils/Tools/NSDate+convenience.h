//
//  NSDate+convenience.h
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)

- (NSDate *)offsetYear:(NSInteger)numYears;
- (NSDate *)offsetMonth:(NSInteger)numMonths;
- (NSDate *)offsetDay:(NSInteger)numDays;
- (NSDate *)offsetHours:(NSInteger)hours;
- (NSInteger)numDaysInMonth;
//------新增
- (NSDate *)nextMonth; //下个月
- (NSInteger)nextMonthDaysInMonth; //下月天数总数
//------
- (NSInteger)firstWeekDayInMonth;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;

+ (NSDate *)dateStartOfDay:(NSDate *)date;
+ (NSDate *)dateStartOfWeek;
+ (NSDate *)dateEndOfWeek;



@end
