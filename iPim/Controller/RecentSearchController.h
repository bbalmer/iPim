//
//  RecentSearchController.h
//  iPim
//
//  Created by Brad Balmer on 6/27/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentSearchController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@end
