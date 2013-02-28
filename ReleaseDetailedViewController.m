//
//  ReleaseDetailedViewController.m
//  Music Find
//
//  Created by Memphis on 12/7/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "ReleaseDetailedViewController.h"
#import "Release.h"
#import "JsonParser.h"
#import "DataController.h"
#import "ReleaseImagesViewController.h"
#import "XMLParser.h"
#import "SearchMarketViewController.h"

@interface ReleaseDetailedViewController ()

@end

@implementation ReleaseDetailedViewController

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
}

-(void)updateUI
{
    self.upperView.autoresizesSubviews = NO;
    self.navigationItem.title = self.theRelease.title;
    self.mainImage.image = self.theRelease.primaryImage;
    if ([self.images count] > 1)
    {
        self.tapForImages.hidden = FALSE;
        self.upperView.frame = CGRectMake(0, 0, 320.0f, 190.0f);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreImages)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        [tap setDelegate:self];
        [self.mainImage addGestureRecognizer:tap];
    }
    else
    {
        self.upperView.frame = CGRectMake(0, 0, 320.0f, 150.0f);
    }
    NSLog(@"frame: %@",NSStringFromCGRect(self.upperView.frame));
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return self.upperView;
//    }
//    else
//    {
//        return nil;
//    }
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 150.0;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)moreImages
{
    [self performSegueWithIdentifier:@"ReleaseImagesSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tracklist";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.theRelease.tracklist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@" %@. %@", [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:0], [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:1]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.theRelease.tracklist objectAtIndex:indexPath.row] objectAtIndex:2]];
    return cell;
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

- (void)viewDidUnload
{
    [self setTapForImages:nil];
    [self setMainImage:nil];
    [self setUpperView:nil];
    [self setSpinner:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

- (IBAction)searchMarket:(id)sender
{
    NSString *str = [NSString stringWithFormat:@"http://www.discogs.com/sell/list?release_id=%d&output=rss", self.theRelease.idNumber];
    NSLog(@"%@",str);
    XMLParser *par = [[XMLParser alloc] initWithDelegate:self :[NSURL URLWithString:str]];
    [self.spinner startAnimating];
    [self.searchButton setHidden:YES];
}

- (void)parseInMidle:(NSMutableArray *)result
{
    [self.theRelease setListingTitles:result];
}

- (void)parseDidComplete:(NSMutableString *)result
{
    NSArray *arr = [result componentsSeparatedByString:@"\n"];
    self.theRelease.listings = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    for (NSString *str in arr)
    {
        [self.theRelease.listings addObject:str];
    }
    [self.theRelease.listings removeLastObject];
    [self performSegueWithIdentifier:@"SearchMarket" sender:self];
    [self.spinner stopAnimating];
    [self.searchButton setHidden:NO];
    NSLog(@"id: %d title: %d",[self.theRelease.listings count],[self.theRelease.listingTitles count]);
}

@end
