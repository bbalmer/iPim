//
//  HttpConnection.h
//  iPim
//
//  Created by Brad Balmer on 6/20/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpConnection : NSObject

+ (NSString*)GET:(NSString *)uri;

@end
