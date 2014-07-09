//
//  HomeController.m
//  iPim
//
//  Created by Brad Balmer on 6/17/14.
//  Copyright (c) 2014 Brad Balmer. All rights reserved.
//

#import "HomeController.h"
#import "ItemViewController.h"
#import "LoginController.h"
#import "Job.h"

@interface HomeController () {
    NSString *returnXML;
    NSMutableArray *jobs;
}

@end

@implementation HomeController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        jobs = [[NSMutableArray alloc] init];
        for(int i=0;i<20;i++) {
            Job *job = [[Job alloc] init];
            job.jobId = i;
            job.nameTx = @"Job Number ";
            job.jobStatCd = 8;
            job.strtDtTm = [[NSDate alloc] init];
            job.endDtTm = [[NSDate alloc] init];
            job.sbmtDtTm = [[NSDate alloc] init];
            [jobs addObject:job];
        }
        
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:@"IM_USERNAME"];
    if(!username) {
        LoginController *ctrl = [[LoginController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewProduct:(id)sender {
    
    ItemViewController *ctrl = [[ItemViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}
- (IBAction)searchAction:(id)sender {
    NSLog(@"Searching...");
    
    NSString *searchUrl = @"https://dev.itemmasterdev.com/v2/item?";
    if([_searchDescription.text length]> 0)
        searchUrl = [[searchUrl stringByAppendingString:@"q="] stringByAppendingString:_searchDescription.text];
    

    NSURL *url = [NSURL URLWithString:searchUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"bbalmer" forHTTPHeaderField:@"username"];
    [request addValue:@"rowe;927" forHTTPHeaderField:@"password"];
    NSURLResponse* response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (data.length > 0 && error == nil) {
        returnXML= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //_apiResponse.text = returnXML;
     }
    
    
    
}

- (IBAction)searchBrandAction:(id)sender {
}

- (IBAction)searchManufacturerAction:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return jobs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"JobCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    Job *job = [jobs objectAtIndex:indexPath.row];
    cell.textLabel.text = @"here is something";
    cell.detailTextLabel.text = job.nameTx;
    
    return cell;
    
}
@end
