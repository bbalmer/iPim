//
//  Items.m
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "Items.h"
#import "Item.h"
#import "IMCategory.h"
#import "Medium.h"
#import "DateUtils.h"
#import "PackageData.h"
#import "UnitOfMeasure.h"

@implementation Items {
    Item *element;
    IMCategory *imCategory;
    Medium *medium;
    PackageData *packageData;
    UnitOfMeasure *measure;
    NSMutableString *elementValue;
}

- (Item *)itemAtIndex:(NSInteger)index {
    
    if(self.items != nil) {
        return [self.items objectAtIndex:index];
    }
    return nil;
}

- (BOOL)parseDocumentWithData:(NSData *)data {
    if(data == nil)
        return NO;
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:NO];
    
    BOOL ok = [xmlParser parse];
    if(ok == NO)
        NSLog(@"Error parsing");
    
    return ok;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidStartDocument");
    self.items = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidEndDocument.  Found %lu items", (unsigned long)[self.items count]);
    element = nil;
    imCategory = nil;
    medium = nil;
    elementValue = nil;
    packageData = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if(namespaceURI != nil)
        NSLog(@"namespace: %@", namespaceURI);
    if(qName != nil)
        NSLog(@"qualifiedName: %@", qName);
    
    if([elementName isEqualToString:@"items"]) {

        [self setCount:[[attributeDict objectForKey:@"count"] intValue]];
        [self setTotalItems:[[attributeDict objectForKey:@"total"] intValue]];
        [self setStart:[[attributeDict objectForKey:@"start"] intValue]];
        
    } else if([elementName isEqualToString:@"item"]) {
        element = [[Item alloc] init];
        [self.items addObject:element];
        [element setItemId:[attributeDict objectForKey:@"id"]];
        [element setStatus:[attributeDict objectForKey:@"status"]];
    } else if([elementName isEqualToString:@"categories"]) {
        if(element.categories == nil) {
            [element setCategories:[[NSMutableArray alloc]init]];
        }
    } else if([elementName isEqualToString:@"category"]) {
        imCategory = [[IMCategory alloc] init];
        [imCategory setType:[attributeDict objectForKey:@"type"]];
        [imCategory setCategoryId:[attributeDict objectForKey:@"id"]];
        [element.categories addObject:imCategory];
    } else if([elementName isEqualToString:@"media"]) {
        
        [element setMedia:[[NSMutableArray alloc]init]];
    } else if([elementName isEqualToString:@"medium"]) {
        medium = [[Medium alloc] init];
        [medium setType:[attributeDict objectForKey:@"type"]];
        [medium setView:[attributeDict objectForKey:@"view"]];
        [medium setMimeType:[attributeDict objectForKey:@"mimeType"]];
        [medium setImageSource:[attributeDict objectForKey:@"imageSource"]];
        
        NSString *addedStr = [attributeDict objectForKey:@"added"];        
        [medium setAdded:[DateUtils UTCtoNSDate:addedStr]];
        [element.media addObject:medium];
    } else if([elementName isEqualToString:@"packageData"]) {
        packageData = [[PackageData alloc] init];
        [element setPackageData:packageData];
    } else if([elementName isEqualToString:@"length"]) {
        measure = [[UnitOfMeasure alloc] init];
        if(packageData)
           [packageData setLength:measure];
    } else if([elementName isEqualToString:@"height"]) {
        measure = [[UnitOfMeasure alloc] init];
        if(packageData)
            [packageData setHeight:measure];
        
    } else if([elementName isEqualToString:@"width"]) {
        measure = [[UnitOfMeasure alloc] init];
        if(packageData)
            [packageData setWidth:measure];
        
    } else if([elementName isEqualToString:@"packageSize"]) {
        measure = [[UnitOfMeasure alloc] init];
        if(packageData)
            [packageData setPackageSize:measure];
    
    } else {
    
    
        
        
        NSLog(@"didStartElement: %@", elementName);
    
        NSEnumerator *attributes = [attributeDict keyEnumerator];
        NSString *key;
        NSString *value;
        while((key = [attributes nextObject]) != nil) {
            value = [attributeDict objectForKey:key];
            NSLog(@"   attribute: %@ = %@", key, value);
        }
    }
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"name"]) {
        [element setName:elementValue];
    } else if([elementName isEqualToString:@"marketingDescription"]) {
        [element setMarketingDescription:elementValue];
    } else if([elementName isEqualToString:@"otherDescription"]) {
        [element setOtherDescription:elementValue];
    } else if([elementName isEqualToString:@"upc"]) {
        if(element.upcs == nil)
            [element setUpcs:[[NSMutableArray alloc] init]];
        [element.upcs addObject:elementValue];
    } else if([elementName isEqualToString:@"category"]) {
        [imCategory setName:elementValue];
    } else if([elementName isEqualToString:@"description"]) {
        [medium setName:elementValue];
    } else if([elementName isEqualToString:@"url"]) {
        [medium setUrl:[NSURL URLWithString:elementValue]];
    } else if([elementName isEqualToString:@"packageData"]) {
        packageData = nil;
        measure = nil;
    } else if([elementName isEqualToString:@"measure"]) {
        if(measure)
            [measure setMeasure:elementValue];
    } else if([elementName isEqualToString:@"uom"]) {
        if(measure)
            [measure setUom:elementValue];
    } else if([elementName isEqualToString:@"packageType"]) {
        if(packageData)
           [packageData setPackageType:elementValue];
    }
    elementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!elementValue) {
        elementValue = [[NSMutableString alloc] init];
    }
    
    [elementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}
@end
