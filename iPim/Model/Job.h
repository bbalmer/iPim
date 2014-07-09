//
//  Job.h
//  iPim
//
//  Created by Brad Balmer on 6/20/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject
    @property NSInteger jobId;
	@property NSString *jobType;
	@property NSInteger jobStatCd;
	@property NSDate *strtDtTm;
	@property NSDate *endDtTm;
	@property NSDate *sbmtDtTm;
	@property NSString *nameTx;

@end
