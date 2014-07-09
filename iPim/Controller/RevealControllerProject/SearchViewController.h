//
//  SearchViewController.h
//  iPim
//
//  Created by Brad Balmer on 6/17/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchDescription;
@property (weak, nonatomic) IBOutlet UITextField *searchUpc;
@property (weak, nonatomic) IBOutlet UITextField *searchBrands;
@property (weak, nonatomic) IBOutlet UITextField *searchManufacturers;

- (IBAction)searchAction:(id)sender;
@end