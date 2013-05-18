//
//  MasterVersionsViewController.m
//  Music Find
//
//  Created by Memphis on 12/14/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "MasterVersionsViewController.h"
#import "Master.h"
#import "JsonParser.h"
#import "DataController.h"
#import "Release.h"
#import "ReleaseDetailsViewController.h"
#import "SVProgressHUD.h"

@interface MasterVersionsViewController ()

@end

@implementation MasterVersionsViewController

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
    return self.releases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.releases objectAtIndex:indexPath.row] title];
    cell.detailTextLabel.text = [[self.releases objectAtIndex:indexPath.row] format];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    [self performSegueWithIdentifier:@"VersionReleaseInfo" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        if ([[segue identifier] isEqualToString:@"VersionReleaseInfo"])
        {
            ReleaseDetailsViewController *rDVC = [segue destinationViewController];
            [rDVC setTheRelease:[self.releases objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
            [rDVC.theRelease setArtist:self.master.artist];
            [rDVC.theRelease setGenre:self.master.genre];
            NSData *data = [NSData dataWithContentsOfURL:rDVC.theRelease.resourceURL];
            NSArray *images = [JsonParser jsonArrayFromData:@"images" data:data];
            [rDVC setImages:images];
            rDVC.primaryImage = [NSURL URLWithString:[DataController primaryImage150FromJson:images]];
            [rDVC.mainImage setImage:rDVC.theRelease.primaryImage];
            NSArray *tracklistArray = [JsonParser jsonArrayFromData:@"tracklist" data:data];
            rDVC.theRelease.tracklist = [[NSMutableArray alloc] init];
            if (tracklistArray)
            {
                for (int i = 0; i < [tracklistArray count]; i++)
                {
                    NSDictionary *dic = [tracklistArray objectAtIndex:i];
                    [rDVC.theRelease.tracklist addObject:[DataController returnTrackList:dic]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (rDVC.primaryImage)
                {
                    rDVC.theRelease.primaryImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:rDVC.primaryImage]];
                }
                else
                {
                    rDVC.theRelease.primaryImage = [UIImage imageNamed:@"no_image.png"];
                }
                [rDVC updateUI];
                rDVC.releaseLabel.text = self.displayTitle;
                [rDVC.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        }
    });
}

-(void)setReleases:(NSMutableArray *)releases
{
    if (_releases != releases)
    {
        _releases = [releases mutableCopy];
    }
}

@end
