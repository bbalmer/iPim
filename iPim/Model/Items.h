//
//  Items.h
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Item;
@interface Items : NSObject <NSXMLParserDelegate>
@property int count;
@property int totalItems;
@property int start;
@property NSMutableArray *items;

-(Item *)itemAtIndex:(NSInteger)index;
-(BOOL)parseDocumentWithData:(NSData *)data;
@end
