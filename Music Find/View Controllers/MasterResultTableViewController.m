//
//  masterResultTableViewController.m
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "MasterResultTableViewController.h"
#import "Artist.h"
#import "Release.h"
#import "DataController.h"
#import "ArtistInfoViewController.h"
#import "Master.h"
#import "MasterVersionsViewController.h"
#import "ReleaseDetailsViewController.h"
#import "SVProgressHUD.h"
#import "JsonParser.h"

dispatch_queue_t concurrentFetchQueue;

@interface MasterResultTableViewController ()

@end

@implementation MasterResultTableViewController

@synthesize dataController = _dataController, query = _query;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)newSearchClicked:(id)sender
{
    self.stopFetch = YES;
    dispatch_suspend(concurrentFetchQueue);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self queryLabel] setText:[NSString stringWithFormat:@"You typed: %@", [self query]]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //better
    concurrentFetchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentFetchQueue, ^{
        if (self.next)
        {
            self.stopFetch = NO;
            NSArray *fetch;
            NSString *next = self.next;
            do {
                fetch = [JsonParser threePageFetch:next stopFetch:self.stopFetch];
                next = [fetch lastObject];
                NSLog(@"%@",next);
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:fetch];
                [tmp removeLastObject];
                fetch = [NSArray arrayWithArray:tmp];
                for (NSData *arrayData in fetch)
                {
                    NSArray *searchResult = [JsonParser jsonArrayFromData:@"results" :arrayData];
                    [self.dataController artistAndReleaseFromJson:searchResult];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    NSLog(@"reload data table: %d",[self.tableView numberOfRowsInSection:2]);
                });
            } while (![next isEqualToString:@"nonext"] && self.stopFetch == NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.stopFetch) {
                    [SVProgressHUD dismissWithSuccess:@"Fetch Complete" afterDelay:3];
                }
            });
        }
        else
        {
            NSLog(@"no next");
        }
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataController sectionCount] == 3)
    {
        if (section == 0)
        {
            return @"Artists";
        }
        else if (section == 1)
        {
            return @"Master Releases";
        }
        else if (section == 2)
        {
            return @"Releases";
        }
    }
    else if ([self.dataController sectionCount] == 2)
    {
        if ((section == 0) && ([self.dataController.artists count] > 0))
        {
            return @"Artists";
        }
        if ((section == 1) && ([self.dataController.masters count] > 0))
        {
            return @"Master Releases";
        }
        if ((section == 2) && ([self.dataController.releases count] > 0))
        {
            return @"Releases";
        }
    }
    else if ([self.dataController sectionCount] == 1)
    {
        if ((section == 0) && ([self.dataController.artists count] > 0))
        {
            return @"Artists";
        }
        else if ((section == 1) && ([self.dataController.masters count] > 0))
        {
            return @"Master Releases";
        }
        else if ((section == 2) && ([self.dataController.releases count] > 0))
        {
            return @"Releases";
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.dataController.artists count];
    }
    else if (section == 1)
    {
        return [self.dataController.masters count];
    }
    else if (section == 2)
    {
        return [self.dataController.releases count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *artistCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:artistCellIdentifier forIndexPath:indexPath];
    NSInteger section = [indexPath section];
    if (section == 0)
    {
        Artist *artist = [[[self dataController] artists] objectAtIndex:indexPath.row];
        [cell.textLabel setText:[artist name]];
    }
    if (section == 2)
    {
        Release *release = [[[self dataController] releases] objectAtIndex:indexPath.row];
        [cell.textLabel setText:[release title]];
    }
    if (section == 1)
    {
        Master *master = [[[self dataController] masters] objectAtIndex:indexPath.row];
        [cell.textLabel setText:[master title]];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    if ([indexPath section] == 0)
    {
        [self performSegueWithIdentifier:@"Artist" sender:self];
    }
    else if ([indexPath section] == 1)
    {
        [self performSegueWithIdentifier:@"Master" sender:[[[self dataController] masters] objectAtIndex:indexPath.row]];
    }
    else if ([indexPath section] == 2)
    {
        [self performSegueWithIdentifier:@"Release" sender:[[[self dataController] releases] objectAtIndex:indexPath.row]];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        if ([[segue identifier] isEqualToString:@"Artist"])
        {
            ArtistInfoViewController *aIVC = [segue destinationViewController];
            [aIVC setArtist:[self.dataController.artists objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
            NSURL *imgURL = [NSURL URLWithString:[aIVC.artist imageURL]];
            NSData * imageData = [NSData dataWithContentsOfURL:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                aIVC.artistName.text = aIVC.artist.name;
                [aIVC loadImageFromURL:imageData];
                [SVProgressHUD dismiss];
            });
        }
        else if ([[segue identifier] isEqualToString:@"Master"])
        {
            MasterVersionsViewController *mVVC = [segue destinationViewController];
            [mVVC setMaster:[self.dataController.masters objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
            [mVVC.master makeVersionsURL];
            NSData *data = [NSData dataWithContentsOfURL:mVVC.master.versionsURL];
            NSArray *versions = [JsonParser jsonArrayFromData:@"versions" :data];
            mVVC.releases = [[NSMutableArray alloc] initWithCapacity:[versions count]];
            [mVVC setReleases:[DataController versionsFromJson:versions]];
            data = [NSData dataWithContentsOfURL:mVVC.master.resourceURL];
            NSArray *genres = [JsonParser jsonArrayFromData:@"genres" :data];
            NSMutableString *res = [[NSMutableString alloc] init];
            if ([genres count] > 1)
            {
                for (NSString *str in genres)
                {
                    NSLog(@"%@",str);
                    [res appendFormat:@"%@, ",str];
                }
                [res substringToIndex:[res length]-1];
            }
            else
            {
                res = [genres objectAtIndex:0];
            }
            mVVC.master.genre = [NSString stringWithString:res];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                mVVC.displayTitle = [sender title];
                [mVVC.tableView reloadData];
            });
        }
        else if ([[segue identifier] isEqualToString:@"Release"])
        {
            ReleaseDetailsViewController *rDVC = [segue destinationViewController];
            [rDVC setTheRelease:[self.dataController.releases objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
            NSData *data = [NSData dataWithContentsOfURL:rDVC.theRelease.resourceURL];
            NSArray *images = [JsonParser jsonArrayFromData:@"images" :data];
            [rDVC setImages:images];
            rDVC.primaryImage = [NSURL URLWithString:[DataController primaryImage150FromJson:images]];
            [rDVC.mainImage setImage:rDVC.theRelease.primaryImage];
            NSArray *tracklistArray = [JsonParser jsonArrayFromData:@"tracklist" :data];
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
                rDVC.releaseLabel.text = [sender title];
                [rDVC updateUI];
                [rDVC.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        }
                   });
}

- (void)viewDidUnload {
    [self setQueryLabel:nil];
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.stopFetch = YES;
    dispatch_suspend(concurrentFetchQueue);
}

-(void)dealloc
{
    [self setDataController:nil];
    [self setQueryLabel:nil];
    [self setQuery:nil];
}

@end
