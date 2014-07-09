//
//  Item.h
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PackageData;
@class IMCategory;
@class Medium;
@interface Item : NSObject

@property NSString *itemId;
@property NSString *status;
@property NSString *name;
@property NSString *marketingDescription;
@property NSString *otherDescription;
@property NSMutableArray *upcs;
@property NSMutableArray *categories;
@property NSString *createdBy;
@property NSString *lastUpdatedBy;
@property NSDate *createdOn;
@property NSDate *lastUpdatedOn;
@property PackageData *packageData;
@property NSMutableArray *media;

- (Medium*)getHeroImage;
@end
