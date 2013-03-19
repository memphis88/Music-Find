//
//  SearchMarketViewController.m
//  Music Find
//
//  Created by Memphis on 12/12/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "SearchMarketViewController.h"
#import "Listing.h"
#import "ListingViewController.h"
#import "SVProgressHUD.h"

@interface SearchMarketViewController ()

@end

@implementation SearchMarketViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listingsArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < self.listings.count; i++)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.discogs.com/marketplace/listings/%@",[_listings objectAtIndex:i]]];
        Listing *listing = [[Listing alloc] initWithURL:url];
        [self.listingsArray addObject:listing];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.listings.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.listingsTitles objectAtIndex:indexPath.row + 1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"ID:%@",[self.listings objectAtIndex:indexPath.row + 1]];
    //NSLog(@"%@",[[self.listingsArray objectAtIndex:indexPath.row] resourceURL]);
    // Configure the cell...
    
    return cell;
}

-(void)setListingsTitles:(NSArray *)listingsTitles
{
    if (_listingsTitles!=listingsTitles)
    {
        _listingsTitles = [listingsTitles mutableCopy];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Listing *listing = [self.listingsArray objectAtIndex:indexPath.row];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        });
        [listing makeListing];
        [listing setDisplayTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"ListingView" sender:listing];
        });
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ListingView"])
    {
        [SVProgressHUD dismiss];
        ListingViewController *lVC = [segue destinationViewController];
        [lVC setTheListing:sender];
        [lVC setTheRelease:self.theRelease];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
