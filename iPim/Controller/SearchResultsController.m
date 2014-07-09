//
//  SearchResultsController.m
//  iPim
//
//  Created by Brad Balmer on 6/25/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "SearchResultsController.h"
#import "SWRevealViewController.h"
#import "SearchData.h"
#import "Items.h"
#import "Item.h"
#import "Medium.h"
#import "URL.h"
#import "SearchRequestService.h"
#import "SearchRequest.h"
#import "PackageData.h"
#import "UnitOfMeasure.h"


@interface SearchResultsController () {
    Items *items;
    int MAX_RESULTS_PER_PAGE;
}
-(void)processRequest:(int)startIndex maxResults:(int)maxResults;
-(void)layoutResults;
-(void)populateItemView:(UIView *)view item:(Item *)item;
-(void)decorateLabel:(UILabel *)label;
@end

@implementation SearchResultsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        items = [[Items alloc] init];
        MAX_RESULTS_PER_PAGE = 15;
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
    
    
    
    [self processRequest:0 maxResults:MAX_RESULTS_PER_PAGE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processRequest:(int)startIndex maxResults:(int)maxResults {
 
    
    NSString *returnXML;
    
    NSString *searchUrl = [URL webServiceBaseUrl];
    searchUrl = [searchUrl stringByAppendingString:@"/item?epl=200&epf=200&epr=200&pi=c"];
    searchUrl = [[searchUrl stringByAppendingString:@"&idx="] stringByAppendingString:[NSString stringWithFormat:@"%d", startIndex]];
    searchUrl = [[searchUrl stringByAppendingString:@"&limit="] stringByAppendingString:[NSString stringWithFormat:@"%d", maxResults]];
    
    
    if([_searchData.description length]> 0)
        searchUrl = [[searchUrl stringByAppendingString:@"&q="] stringByAppendingString:_searchData.description];
    if([_searchData.upc length]> 0)
        searchUrl = [[searchUrl stringByAppendingString:@"&upc="] stringByAppendingString:_searchData.upc];
    if([_searchData.brandId length]> 0)
        searchUrl = [[searchUrl stringByAppendingString:@"&b="] stringByAppendingString:_searchData.brandId];
    if([_searchData.manufacturerId length]> 0)
        searchUrl = [[searchUrl stringByAppendingString:@"&m="] stringByAppendingString:_searchData.manufacturerId];

     
    NSURL *url = [NSURL URLWithString:searchUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"bbalmer" forHTTPHeaderField:@"username"];
    [request addValue:@"rowe;927" forHTTPHeaderField:@"password"];
    NSURLResponse* response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error)
        NSLog(@"ERROR: %@", error.debugDescription);
    if (data.length > 0 && error == nil) {
        returnXML= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    NSData *xmlData = [returnXML dataUsingEncoding:NSUTF8StringEncoding];
    [items parseDocumentWithData:xmlData];
    
    
    SearchRequest *searchRequest = [[SearchRequestService service] create:_searchData mfgName:@"" brndName:@"" resultCount:[items count]];
    [searchRequest setResultCount:[NSNumber numberWithInt:items.totalItems]];
    [[SearchRequestService service] save];
    
    
    [self layoutResults];
   
}

-(void)layoutResults {
    int maxRowCount = 3;
    int xpos = 50;
    int ypos = 0;
    
    int itemFrameHeight = 300;
    int itemFrameWidth = 300;
    int rowCount = 0;
    
    for(Item *item in items.items) {
        rowCount++;
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(xpos, ypos, itemFrameWidth, itemFrameHeight)];
        UIColor *background = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];//[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"itemBkgrnd"]];
        itemView.backgroundColor = background;
        [self populateItemView:itemView item:item];
        [_scrollView addSubview:itemView];
        
        if(rowCount == maxRowCount) {
            rowCount = 0;
            xpos = 50;
            ypos += (itemFrameHeight + 25);
        } else {
            xpos += (itemFrameWidth + 25);
        }
    }
    int totalRows = (int)[items.items count] / maxRowCount;
    if(([items.items count] % maxRowCount) > 0)
        totalRows++;
    
    _scrollView.contentSize = CGSizeMake(1024, ((totalRows * itemFrameHeight)+(totalRows * 25)));
    
}

- (void)decorateLabel:(UILabel *)label {
    label.numberOfLines=0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    label.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
}

- (void)populateItemView:(UIView *)view item:(Item *)item {
    Medium *heroImage = [item getHeroImage];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, view.frame.size.width - 40, 40)];
    description.text = item.name;
    description.numberOfLines=3;
    description.lineBreakMode = NSLineBreakByWordWrapping;
    description.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    description.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [description sizeToFit];
    [view addSubview:description];
    
    UILabel *upcLabel =[[UILabel alloc] initWithFrame:CGRectMake(120, view.frame.size.height - 110, view.frame.size.width - 40, 20)];
    upcLabel.text =@"UPC";
    upcLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    upcLabel.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:upcLabel];
    
    UILabel *upc = [[UILabel alloc] initWithFrame:CGRectMake(120, view.frame.size.height - 90, view.frame.size.width - 40, 20)];
    if([item.upcs count] > 0)
        upc.text = [item.upcs objectAtIndex:0];
    [upc sizeToFit];
    upc.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    upc.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:upc];
    
    UILabel *productSizeLabel =[[UILabel alloc] initWithFrame:CGRectMake(120, view.frame.size.height - 60, view.frame.size.width - 40, 20)];
    productSizeLabel.text =@"Item Size";
    productSizeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    productSizeLabel.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:productSizeLabel];
    
    UILabel *productSize = [[UILabel alloc] initWithFrame:CGRectMake(120, view.frame.size.height - 40, view.frame.size.width - 40, 20)];
    if(item.packageData && item.packageData.packageSize) {
        NSString *size = [[item.packageData.packageSize.measure stringByAppendingString:@" "]stringByAppendingString:item.packageData.packageSize.uom];
        productSize.text = size;
    }
    [productSize sizeToFit];
    productSize.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    productSize.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:productSize];
    
    
    
    UILabel *manufacturerLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 80, view.frame.size.width - 40, 20)];
    manufacturerLabel.text =@"Manufacturer";
    manufacturerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    manufacturerLabel.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:manufacturerLabel];
    
    UILabel *manufacturer = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, view.frame.size.width - 40, 20)];
    manufacturer.text = [item.upcs objectAtIndex:0];
    [manufacturer sizeToFit];
    manufacturer.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    manufacturer.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:manufacturer];
    
    
    UILabel *brandLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 130, view.frame.size.width - 40, 20)];
    brandLabel.text =@"Brand";
    brandLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    brandLabel.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:brandLabel];
    
    UILabel *brand = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, view.frame.size.width - 40, 20)];
    brand.text = [item.upcs objectAtIndex:0];
    [brand sizeToFit];
    brand.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    brand.textColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    [view addSubview:brand];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, view.frame.size.height - 110, 100, 100)];
    UIColor *bdColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    imageView.layer.borderColor = bdColor.CGColor;
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    
    [view addSubview:imageView];
    UIColor *blueColor = [UIColor colorWithRed:18/255.0 green:83/255.0 blue:137/255.0 alpha:1];
    view.layer.borderColor = blueColor.CGColor;
    view.layer.borderWidth = 3.0f;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *image;
        if(heroImage) {
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:heroImage.url];
            image = [UIImage imageWithData:imageData];
        } else {
            image = [UIImage imageNamed:@"photoNotAvailable"];
        }
        imageView.image = image;
        
    });
}

@end
