//
//  Medium.h
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medium : NSObject

@property NSString *type;
@property NSString *view;
@property NSString *mimeType;
@property NSString *imageSource;
@property NSDate *added;
@property NSString *name;
@property NSURL *url;

@end
