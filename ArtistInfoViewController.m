//
//  ArtistInfoViewController.m
//  Music Find
//
//  Created by Memphis on 11/26/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "ArtistInfoViewController.h"
#import "DescriptionViewController.h"
#import "Artist.h"
#import "Master.h"
#import "Release.h"
#import "ArtistReleasesViewController.h"
#import "JsonParser.h"
#import "DataController.h"
#import "ArtistLinksViewController.h"
#import "SVProgressHUD.h"
#import "ReleaseImagesViewController.h"

@interface ArtistInfoViewController ()

@end

@implementation ArtistInfoViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if ([[segue identifier] isEqualToString:@"DescriptionSegue"])
    {
        dispatch_async(concurrentQueue, ^{
            DescriptionViewController *dVC = [segue destinationViewController];
            [dVC setArtist:self.artist];
            [dVC loadDescription];
            dispatch_async(dispatch_get_main_queue(), ^{
                [dVC.descriptionText setText:dVC.artist.description];
                [dVC.artistName setText:dVC.artist.name];
                [dVC.artistName sizeToFit];
                [dVC.artistName setCenter:CGPointMake(160, 28)];
                [SVProgressHUD dismiss];
            });
        });
    }
    else if ([[segue identifier] isEqualToString:@"ReleasesSegue"])
    {
        dispatch_async(concurrentQueue, ^{
            ArtistReleasesViewController *aRVC = [segue destinationViewController];
            aRVC.artistName = self.artist.name;
            self.artist.releasesURL = [NSURL URLWithString:[JsonParser jsonValueFromData:@"releases_url" :[NSData dataWithContentsOfURL:self.artist.resourceURL]]];
            NSData *reldata = [NSData dataWithContentsOfURL:self.artist.releasesURL];
            NSArray *releasesResult;
            aRVC.flag = @"all";
            aRVC.masters = [[NSMutableArray alloc] init];
            aRVC.releases = [[NSMutableArray alloc] init];
            aRVC.mainMasters = [[NSMutableArray alloc] init];
            aRVC.mainReleases = [[NSMutableArray alloc] init];
            aRVC.otherMasters = [[NSMutableArray alloc] init];
            aRVC.otherReleases = [[NSMutableArray alloc] init];
            if (![JsonParser paginationCheck:reldata])
            {
                NSArray *all = [JsonParser jsonArrayFromData:@"releases" :reldata];
                aRVC.masters = [DataController mastersFromJson:all];
                aRVC.releases = [DataController releasesFromJson:all];
                for (Master *mast in aRVC.masters) {
                    if ([mast.role isEqualToString:@"Main"]) {
                        [aRVC.mainMasters addObject:mast];
                    }
                    else
                    {
                        [aRVC.otherMasters addObject:mast];
                    }
                }
                for (Release *rel in aRVC.releases) {
                    if ([rel.role isEqualToString:@"Main"]) {
                        [aRVC.mainReleases addObject:rel];
                    }
                    else
                    {
                        [aRVC.otherReleases addObject:rel];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [aRVC.tableView reloadData];
                    [SVProgressHUD dismiss];
                });
            }
            else
            {
                NSArray *pagedJSONData;
                NSString *next;
                if ([[[JsonParser jsonArrayFromData:@"pagination" :reldata] valueForKey:@"pages"] integerValue] <= 5)
                {
                    pagedJSONData = [JsonParser pagesFromData:reldata];
                }
                else
                {
                    NSArray *tmpArr = [JsonParser moreThanFive:reldata];
                    next = [tmpArr lastObject];
                    NSMutableArray *tmpMutArr = [NSMutableArray arrayWithArray:tmpArr];
                    [tmpMutArr removeLastObject];
                    pagedJSONData = [NSArray arrayWithArray:tmpMutArr];
                }
                for (NSData *arrayData in pagedJSONData)
                {
                    releasesResult = [JsonParser jsonArrayFromData:@"releases" :arrayData];
                    [aRVC.masters addObjectsFromArray:[DataController mastersFromJson:releasesResult]];
                    [aRVC.releases addObjectsFromArray:[DataController releasesFromJson:releasesResult]];
                }
                for (Master *mast in aRVC.masters) {
                    if ([mast.role isEqualToString:@"Main"]) {
                        [aRVC.mainMasters addObject:mast];
                    }
                    else
                    {
                        [aRVC.otherMasters addObject:mast];
                    }
                }
                for (Release *rel in aRVC.releases) {
                    if ([rel.role isEqualToString:@"Main"]) {
                        [aRVC.mainReleases addObject:rel];
                    }
                    else
                    {
                        [aRVC.otherReleases addObject:rel];
                    }
                }
                NSLog(@"%@",next);
                [aRVC continueFetch:next];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [aRVC.tableView reloadData];
                    [SVProgressHUD dismiss];
                });

            }
        });
    }
    else if ([[segue identifier] isEqualToString:@"ArtistImagesSegue"])
    {
        dispatch_async(concurrentQueue, ^{
            ReleaseImagesViewController *rIVC = [segue destinationViewController];
            [rIVC setImages:[JsonParser jsonArrayFromData:@"images" :[NSData dataWithContentsOfURL:self.artist.resourceURL]]];
            NSLog(@"%@",rIVC.images);
            rIVC.imagesData = [[NSMutableArray alloc] initWithCapacity:rIVC.images.count];
            dispatch_async(dispatch_get_main_queue(), ^{
                [rIVC.collectionView reloadData];
                [SVProgressHUD dismiss];
            });
        });
    }
    else if ([[segue identifier] isEqualToString:@"LinksSegue"])
    {
        dispatch_async(concurrentQueue, ^{
            ArtistLinksViewController *aLVC = [segue destinationViewController];
            aLVC.links = self.artist.links;
            aLVC.artistName = self.artist.name;
            aLVC.navigationItem.title = aLVC.artistName;
            dispatch_async(dispatch_get_main_queue(), ^{
                [aLVC.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        });
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"DescriptionSegue" sender:self];
    }
    else if (indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"ReleasesSegue" sender:self];
    }
    else if (indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"ArtistImagesSegue" sender:self];
    }
    else if (indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"LinksSegue" sender:self];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((self.artist.links = [JsonParser jsonArrayFromData:@"urls" :[NSData dataWithContentsOfURL:self.artist.resourceURL]]))
    {
        return 4;
    }
    else
    {
        return 3;
    }
}

- (void)loadImageFromURL:(NSData *)data
{
    [self.imageIndicator startAnimating];
    self.artistThumb.image = [UIImage imageWithData:data];
    [self.imageIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setArtistThumb:nil];
    [self setArtistName:nil];
    [self setLinksCell:nil];
    [super viewDidUnload];
}
@end
