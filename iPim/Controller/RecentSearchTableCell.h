//
//  RecentSearchTableCell.h
//  iPim
//
//  Created by Brad Balmer on 6/27/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentSearchTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *upc;
@property (weak, nonatomic) IBOutlet UILabel *brand;
@property (weak, nonatomic) IBOutlet UILabel *manufacturer;
@property (weak, nonatomic) IBOutlet UILabel *updatedSince;
@property (weak, nonatomic) IBOutlet UILabel *resultCount;

@property (weak, nonatomic) IBOutlet UILabel *searchDate;
@end
