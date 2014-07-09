//
//  SearchRequest.h
//  iPim
//
//  Created by Brad Balmer on 6/26/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchRequest : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * upc;
@property (nonatomic, retain) NSString * manufacturerId;
@property (nonatomic, retain) NSString * manufacturerName;
@property (nonatomic, retain) NSString * brandId;
@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSDate * sinceDate;
@property (nonatomic, retain) NSNumber * resultCount;
@property (nonatomic, retain) NSDate * searchDate;

@end
