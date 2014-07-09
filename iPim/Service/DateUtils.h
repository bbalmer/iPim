//
//  DateUtils.h
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject
+ (NSDate *)UTCtoNSDate:(NSString *)stringUtcDate;
@end
