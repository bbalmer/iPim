//
//  DateUtils.m
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils
+ (NSDate *)UTCtoNSDate:(NSString *)stringUtcDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.sss'-05:00'"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"US/Central"]];
    NSDate *added = [dateFormat dateFromString:stringUtcDate];
    return added;
}
@end
