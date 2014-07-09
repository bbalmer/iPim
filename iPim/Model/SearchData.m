//
//  SearchData.m
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "SearchData.h"

@implementation SearchData

- (BOOL)isValidForSearch {
    BOOL isValid = NO;
    
    if([self.description length] > 0)
        isValid = YES;
    
    if([self.upc length] > 0)
        isValid = YES;
    
    if([self.manufacturerId length] > 0)
        isValid = YES;
    
    if([self.brandId length] > 0)
        isValid = YES;
    
    if(self.sinceDate != nil)
        isValid = YES;
    
    return isValid;
}
@end
