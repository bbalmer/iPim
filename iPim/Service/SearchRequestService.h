//
//  SearchRequestService.h
//  iPim
//
//  Created by Brad Balmer on 6/26/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class SearchRequest;
@class SearchData;

@interface SearchRequestService : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (SearchRequestService *)service;
- (SearchRequest *)create:(SearchData *)searchData mfgName:(NSString *)mfgName brndName:(NSString *)brndName resultCount:(NSInteger)resultCount;
- (BOOL)save;
- (SearchRequest *)loadByManagedObjectId:(NSManagedObjectID *)objectId;
- (NSArray *)loadAll;
- (NSArray *)loadAllSince:(NSDate *)sinceDate;
- (void)remove:(SearchRequest *)sr;
@end
