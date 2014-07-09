/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
*/

#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "ItemViewController.h"
#import "LoginController.h"
#import "SearchData.h"
#import "SearchResultsController.h"

@interface SearchViewController()

@end

@implementation SearchViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:@"IM_USERNAME"];
    if(!username) {
        LoginController *ctrl = [[LoginController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    
//    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
//        style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
//    
//    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

- (IBAction)searchAction:(id)sender {
   
    SearchData *searchData = [[SearchData alloc] init];
    [searchData setDescription:_searchDescription.text];
    [searchData setUpc:_searchUpc.text];
    [searchData setManufacturerId:_searchManufacturers.text];
    [searchData setBrandId:_searchBrands.text];
    [searchData setSinceDate:nil];
    
    if([searchData isValidForSearch]) {
         SWRevealViewController *revealController = self.revealViewController;
        SearchResultsController *ctrl = [[SearchResultsController alloc] init];
        [ctrl setSearchData:searchData];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [revealController pushFrontViewController:navigationController animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Invalid Search"
                                                        message: @"One form value is required to search"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
@end