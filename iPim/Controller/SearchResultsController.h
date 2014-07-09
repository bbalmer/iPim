//
//  SearchResultsController.h
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchData;

@interface SearchResultsController : UIViewController
@property SearchData *searchData;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
