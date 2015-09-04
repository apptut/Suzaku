//
//  NSDate+ITK_Time.m
//  Muse
//
//  Created by liangqi on 15/6/3.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "NSDate+ITK_Time.h"

@implementation NSDate (ITK_Time)

- (long)itk_timestamp{
    return (long)([self timeIntervalSince1970]);
}

- (long)itk_timestampNow{
    return (long)([[NSDate date] timeIntervalSince1970] * 1000);
}

+ (NSDate *) itk_stringToDate:(NSString *)format time:(NSString *)time{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [self timeZone];
    formatter.dateFormat = format;
    return [formatter dateFromString:time];
}

- (NSString *) itk_toString:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSDate timeZone];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

-(NSDate *) itk_lastMondayBeforeDate{
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:self];
    
    NSInteger weekday = [comps weekday];
    weekday = weekday==1 ? 6 : weekday-2;
    
    NSTimeInterval secondsSinceMondayMidnight =(NSUInteger) weekday * 60*60*24;
    
    return [self dateByAddingTimeInterval:-secondsSinceMondayMidnight];
}

-(NSDate *) itk_nextMondayAfterDate{
    return [[self itk_lastMondayBeforeDate]dateByAddingTimeInterval:60*60*24*7];
}


- (NSDate *) itk_dayStart:(int)hour{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    comps.hour = hour;
    comps.minute = 0;
    comps.second = 0;
    
    [comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    
    return [cal dateFromComponents:comps];
    
}

- (NSString *)itk_getMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    if (components.month < 10) {
        return [NSString stringWithFormat:@"0%ld",components.month];
    }else{
        return [NSString stringWithFormat:@"%ld",components.month];
    }
}

- (NSInteger) itk_getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return components.day;
}

#pragma mark - 私有方法
+ (NSDate *) localDate{
    NSDate *curUTCDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: curUTCDate];
    return [curUTCDate dateByAddingTimeInterval: interval];
}
- (NSDate *) localDate{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: self];
    return [self dateByAddingTimeInterval: interval];
}


- (NSDate *) itk_rangeEnd:(int)days{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    [components setDay:[components day] + days];
    
    return [calendar dateFromComponents:components];
}

+ (NSTimeZone *) timeZone{
    return [NSTimeZone localTimeZone];
}

+ (NSInteger)itk_daysBetweenDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime;
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (NSInteger) itk_getTotalDaysFromCurrentMonth{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    
    return days.length;
}

- (NSDate *) itk_getFirstDayOfMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    [components setDay:1];
    
    return [calendar dateFromComponents:components];
    
    
}

@end
