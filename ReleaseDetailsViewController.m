//
//  ReleaseDetailsViewController.m
//  Music Find
//
//  Created by Memphis on 1/9/13.
//  Copyright (c) 2013 Memphis. All rights reserved.
//

#import "ReleaseDetailsViewController.h"
#import "Release.h"
#import "ReleaseImagesViewController.h"
#import "SearchMarketViewController.h"
#import "XMLParser.h"

@interface ReleaseDetailsViewController ()

@end

@implementation ReleaseDetailsViewController

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
    [self.scrollView addSubview:self.tableView];
    [self.tableView setScrollEnabled:NO];
	[self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView sizeToFit];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([[[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@""])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:1]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:2]];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@" %@. %@", [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:0], [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:1]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:2]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchMarket:(id)sender
{
    NSString *str = [NSString stringWithFormat:@"http://www.discogs.com/sell/list?release_id=%d&output=rss", self.theRelease.idNumber];
    NSLog(@"%@",str);
    XMLParser *par = [[XMLParser alloc] initWithDelegate:self :[NSURL URLWithString:str]];
    [self.spinner startAnimating];
    [self.searchButton setHidden:YES];
}

-(void)moreImages
{
    [self performSegueWithIdentifier:@"ReleaseImagesSegue" sender:self];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tracklist";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.theRelease.tracklist.count;
}

-(void)updateUI
{
    self.navigationItem.title = self.theRelease.title;
    self.mainImage.image = self.theRelease.primaryImage;
    if ([self.images count] > 1)
    {
        [self.tapForImages setHidden:NO];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreImages)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        [tap setDelegate:self];
        [self.mainImage addGestureRecognizer:tap];
    }
    self.labelName.text = self.theRelease.label;
    self.genreLabel.text = self.theRelease.genre;
    [self.tableView reloadData];
    self.view.frame = CGRectMake(0, 0, 320, self.tableView.contentSize.height+270);
    self.scrollView.frame = CGRectMake(0, 0, 320, 416);
    if ((self.tableView.contentSize.height+270) > 416)
    {
        self.scrollView.contentSize = CGSizeMake(320, self.tableView.contentSize.height+270);
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(320, 416);
    }
    self.tableView.frame = CGRectMake(0, 190, self.tableView.contentSize.width, self.tableView.contentSize.height);
    [self.searchButton setHidden:NO];
    self.searchButton.frame = CGRectMake(self.searchButton.frame.origin.x, self.tableView.frame.size.height+210, self.searchButton.frame.size.width, self.searchButton.frame.size.height);
    self.spinner.center = CGPointMake(self.searchButton.center.x, self.searchButton.center.y);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReleaseImagesSegue"])
    {
        ReleaseImagesViewController *rIVC = [segue destinationViewController];
        [rIVC setImages:[NSArray arrayWithArray:self.images]];
    }
    if ([[segue identifier] isEqualToString:@"SearchMarket"])
    {
        NSLog(@" id: %@, title:%@",self.theRelease.listings, self.theRelease.listingTitles);
        SearchMarketViewController *sMVC = [segue destinationViewController];
        [sMVC setListings:[NSArray arrayWithArray:self.theRelease.listings]];
        [sMVC setListingsTitles:[NSArray arrayWithArray:self.theRelease.listingTitles]];
        [sMVC setTheRelease:self.theRelease];
    }
}

- (void)parseTitles:(NSMutableArray *)result
{
    [self.theRelease setListingTitles:result];
}

- (void)parseIDs:(NSMutableString *)result
{
    NSArray *arr = [result componentsSeparatedByString:@"\n"];
    self.theRelease.listings = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    for (NSString *str in arr)
    {
        [self.theRelease.listings addObject:str];
    }
    [self.theRelease.listings removeLastObject];
    if ([self.theRelease.listings count] > 1)
    {
        [self performSegueWithIdentifier:@"SearchMarket" sender:self];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nothing found!"
                                                          message:@"There are no listings for the selected item at the moment, please try a different version."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    [self.spinner stopAnimating];
    [self.searchButton setHidden:NO];
}

@end
