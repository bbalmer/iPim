//
//  URL.m
//  iPim
//
//  Created by Brad Balmer on 6/19/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "URL.h"

@implementation URL
    
NSString *devWebServiceBaseUri = @"http://dev.itemmasterdev.com/v2";
NSString *prodWebServiceBaseUri = @"https://api.itemmaster.com/v2";


+ (NSString *)webServiceBaseUrl {
    
    return devWebServiceBaseUri;
}

@end
