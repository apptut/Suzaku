//
//  NSDate+ITK_Time.h
//  Muse
//
//  Created by liangqi on 15/6/3.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ITK_Time)

/**
 *  获取给定时间的当前时间戳毫秒值
 *
 *  @return 毫秒值时间戳
 */
- (long) itk_timestamp;

/**
 *  返回当前时间的时间戳毫秒值
 *
 *  @return 时间戳
 */
- (long) itk_timestampNow;

/**
 *  转换字符串时间为NSDate，默认时区+0800，如："2010-10-10 10:00:01" => NSDate()
 *
 *  @param format "yy-MM-dd HH:mm:ss"
 *  @param time   2010-10-10 10:00:01
 *
 *  @return NSDate
 */
+ (NSDate *) itk_stringToDate:(NSString *)format time:(NSString *)time;


/**
 *  NSDate => time string such as 2014-10-10
 *
 *  @param format such as yy-MM-dd
 *
 *  @return NSString
 */
- (NSString *) itk_toString:(NSString *)format;


/**
 *  calculate days between to NSDate
 *
 *  @param fromDateTime from Date
 *  @param toDateTime   to Date
 *
 *  @return int days
 */
+ (NSInteger)itk_daysBetweenDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime;


-(NSDate *) itk_lastMondayBeforeDate;
-(NSDate *) itk_nextMondayAfterDate;

+ (NSDate *) localDate;
- (NSDate *) localDate;

- (NSDate *) itk_rangeEnd:(int)days;

- (NSDate *) itk_dayStart:(int)hour;

- (NSInteger) itk_getDay;

- (NSString*) itk_getMonth;


/**
 *  获取当前月份总共有多少天
 *
 *  @return nums
 */
- (NSInteger) itk_getTotalDaysFromCurrentMonth;


/**
 *  获取一个月中的第一天日期
 *
 *  @return NSDate
 */
- (NSDate *) itk_getFirstDayOfMonth;


@end
