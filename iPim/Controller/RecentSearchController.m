//
//  RecentSearchController.m
//  iPim
//
//  Created by Brad Balmer on 6/27/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "RecentSearchController.h"
#import "SWRevealViewController.h"
#import "RecentSearchTableCell.h"
#import "SearchRequestService.h"
#import "SearchResultsController.h"
#import "SearchRequest.h"
#import "SearchData.h"

@interface RecentSearchController () {
    NSArray *requests;
}

@end

@implementation RecentSearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    _searchTable.delegate = self;
    requests = [[SearchRequestService service]loadAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//    }
//    SearchRequest *sr = [requests objectAtIndex:indexPath.row];
//    NSString *resultCount = [[@"Found " stringByAppendingString:[sr.resultCount stringValue]] stringByAppendingString:@" results"];
//    
//    cell.textLabel.text = resultCount;
//    return cell;
    
    RecentSearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentSearchTableCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"RecentSearchTableCell" bundle:nil] forCellReuseIdentifier:@"RecentSearchTableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"RecentSearchTableCell"];
    }

    SearchRequest *sr = [requests objectAtIndex:indexPath.row];
    NSString *resultCount = [[sr.resultCount stringValue] stringByAppendingString:@" results"];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    [dateFmt setDateFormat:@"MM/dd/yyyy"];
    
    cell.description.text = sr.name;
    cell.upc.text = sr.upc;
    cell.brand.text = sr.brandName;
    cell.manufacturer.text = sr.manufacturerName;
    if(sr.sinceDate)
        cell.updatedSince.text = [dateFmt stringFromDate:sr.sinceDate];
    cell.resultCount.text = resultCount;
    
    cell.searchDate.text = [dateFmt stringFromDate:sr.searchDate];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [requests count];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchRequest *sr = [requests objectAtIndex:indexPath.row];
    SearchData *searchData = [[SearchData alloc] init];
    [searchData setDescription:sr.name];
    [searchData setUpc:sr.upc];
    [searchData setManufacturerId:sr.manufacturerId];
    [searchData setBrandId:sr.brandId];
    [searchData setSinceDate:sr.sinceDate];
    
    
    SWRevealViewController *revealController = self.revealViewController;
    SearchResultsController *ctrl = [[SearchResultsController alloc] init];
    [ctrl setSearchData:searchData];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [revealController pushFrontViewController:navigationController animated:YES];
}

@end
