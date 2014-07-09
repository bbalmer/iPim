//
//  PackageData.h
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UnitOfMeasure;

@interface PackageData : NSObject
@property UnitOfMeasure *length;
@property UnitOfMeasure *height;
@property UnitOfMeasure *width;
@property NSString *packageType;
@property UnitOfMeasure *packageSize;
@property UnitOfMeasure *netWeight;
@end
