//
//  HttpConnection.m
//  iPim
//
//  Created by Brad Balmer on 6/20/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "HttpConnection.h"
#import "URL.h"
#import "SSKeychain.h"

@implementation HttpConnection

+ (NSString*)GET:(NSString *)uri {
    NSString *searchUrl = [[URL webServiceBaseUrl] stringByAppendingString:uri];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:@"IM_USERNAME"];
    
    NSString *pwdSvc = @"IM";
    NSString *acctId = username;
    NSString *pwdSystem = [SSKeychain passwordForService:pwdSvc account:acctId];
    
    NSString *returnXML;
    NSURL *url = [NSURL URLWithString:searchUrl];
    
    NSLog(@"URL: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:username forHTTPHeaderField:@"username"];
    [request addValue:pwdSystem forHTTPHeaderField:@"password"];
    NSURLResponse* response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (data.length > 0 && error == nil) {
        returnXML= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return returnXML;
}
@end
