//
//  Item.m
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "Item.h"
#import "Medium.h"
@implementation Item

- (Medium *)getHeroImage {
    Medium *hero;
    if(self.media) {
        
        for(hero in self.media) {
            if ([hero.view rangeOfString:@"A1A3"].location == NSNotFound) {
                hero = nil;
            } else {
                return hero;
            }
        }
        for(hero in self.media) {
            if ([hero.view rangeOfString:@"A1R1"].location == NSNotFound) {
                hero = nil;
            } else {
                return hero;
            }
        }
        for(hero in self.media) {
            if ([hero.view rangeOfString:@"A1L1"].location == NSNotFound) {
                hero = nil;
            } else {
                return hero;
            }
        }
    }
        
    return hero;
}
@end
