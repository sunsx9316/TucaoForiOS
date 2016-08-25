//
//  NSString+Tools.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
+ (NSString *)stringWithFormatNum:(NSInteger)num {
    if (num >= 10000) {
        return [NSString stringWithFormat:@"%.1lf万",num * 1.0 / 10000];
    }
    return [NSString stringWithFormat:@"%ld", (long)num];
}

+ (NSString *)stringWithCreatTime:(NSString *)time {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    date = [date dateByAddingTimeInterval: interval];
    
    NSDate *nowDate = [NSDate date];
    interval = [zone secondsFromGMTForDate: nowDate];
    nowDate = [nowDate dateByAddingTimeInterval: interval];
    
    NSString *timeStr = nil;
    if (nowDate.year - date.year > 1) {
        timeStr = [date stringWithFormat:@"yyyy-MM-dd"];
    }
    else if (nowDate.month - date.month >= 1 && nowDate.month - date.month <= 12) {
        timeStr = [NSString stringWithFormat:@"%ld个月前", nowDate.month - date.month];
    }
    else if (nowDate.day - date.day <= 30 && nowDate.day - date.day >= 1) {
        timeStr = [NSString stringWithFormat:@"%ld天前", nowDate.day - date.day];
    }
    else if (nowDate.hour - date.hour <= 24 && nowDate.hour - date.hour >= 1) {
        timeStr = [NSString stringWithFormat:@"%ld小时前", nowDate.hour - date.hour];
    }
    else if (nowDate.minute - date.minute <= 60 && nowDate.minute - date.minute >= 1) {
        timeStr = [NSString stringWithFormat:@"%ld分钟前", nowDate.minute - date.minute];
    }
    else if (nowDate.minute - date.minute < 1) {
        timeStr = @"刚刚";
    }
    return timeStr;
}
@end
