//
//  SearchData.h
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchData : NSObject
@property NSString *description;
@property NSString *upc;
@property NSString *manufacturerId;
@property NSString *brandId;
@property NSDate *sinceDate;

- (BOOL)isValidForSearch;
@end
