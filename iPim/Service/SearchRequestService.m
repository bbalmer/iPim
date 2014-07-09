//
//  SearchRequestService.m
//  iPim
//
//  Created by Brad Balmer on 6/26/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "SearchRequestService.h"
#import "AppDelegate.h"
#import "SearchRequest.h"
#import "SearchData.h"

static NSString *SEARCH_REQUEST = @"SearchRequest";

@implementation SearchRequestService

+(SearchRequestService *)service {
    static SearchRequestService *service = nil;
    if(!service)
        service = [[super allocWithZone:nil] init];
    return service;
}

+(id)allocWithZone:(struct _NSZone *)zone {
    return [self service];
}

-(id)init {
    self = [super init];
    if(self) {
        
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        context = [appDelegate managedObjectContext];
        model = [appDelegate managedObjectModel];
        
    }
    return self;
}

- (SearchRequest *)create:(SearchData *)searchData mfgName:(NSString *)mfgName brndName:(NSString *)brndName resultCount:(NSInteger)resultCount{
    SearchRequest *s = [NSEntityDescription insertNewObjectForEntityForName:SEARCH_REQUEST
                                                     inManagedObjectContext:context];
    s.searchDate = [NSDate date];
    s.name = searchData.description;
    s.brandId = searchData.brandId;
    s.brandName = brndName;
    s.manufacturerId = searchData.manufacturerId;
    s.manufacturerName = mfgName;
    s.upc = searchData.upc;
    s.sinceDate = searchData.sinceDate;
    s.resultCount = [NSNumber numberWithInteger:resultCount];
    
    return s;
}

- (BOOL)save {
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if(!successful)
        NSLog(@"Error savign %@", [err localizedDescription]);
    
    return successful;
}


- (SearchRequest *)loadByManagedObjectId:(NSManagedObjectID *)objectId {
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:SEARCH_REQUEST];
    [request setEntity:e];
    NSError *error;
    return (SearchRequest *)[context existingObjectWithID:objectId error:&error];
}

- (NSArray *)loadAll {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:SEARCH_REQUEST];
    [request setEntity:e];

    NSSortDescriptor *sd = [NSSortDescriptor
                            sortDescriptorWithKey:@"searchDate" ascending:NO];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if(!result) {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        
    }
    
    return result;
}

- (NSArray *)loadAllSince:(NSDate *)sinceDate {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:SEARCH_REQUEST];
    [request setEntity:e];
    [request setPredicate:[NSPredicate predicateWithFormat:@"searchDate == %@ ", sinceDate]];
    
    
    NSSortDescriptor *sd = [NSSortDescriptor
                            sortDescriptorWithKey:@"searchDate" ascending:NO];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sd]];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if(!result) {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        
    }
    
    return result;
}

- (void)remove:(SearchRequest *)sr {
    SearchRequest *request = [self loadByManagedObjectId:sr.objectID];
    [context deleteObject:request];
    [self save];
}

@end
