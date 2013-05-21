//
//  ArtistReleasesViewController.m
//  Music Find
//
//  Created by Memphis on 12/5/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "ArtistReleasesViewController.h"
#import "Release.h"
#import "Master.h"
#import "ReleaseDetailsViewController.h"
#import "MasterVersionsViewController.h"
#import "SVProgressHUD.h"
#import "JsonParser.h"
#import "DataController.h"
#import "SVProgressHUD.h"

dispatch_queue_t concurrentFetchQueue;

@interface ArtistReleasesViewController ()

@end

@implementation ArtistReleasesViewController

/*
 * Κατασκευαστής για τη χρήση αρχείων Nib
 */

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setMasters:(NSMutableArray *)masters
{
    if (_masters!=masters)
    {
        _masters = [masters mutableCopy];
    }
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setReleases:(NSMutableArray *)releases
{
    if (_releases!=releases)
    {
        _releases = [releases mutableCopy];
    }
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setMainMasters:(NSMutableArray *)mainMasters
{
    if (_mainMasters!=mainMasters)
    {
        _mainMasters = [mainMasters mutableCopy];
    }
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setMainReleases:(NSMutableArray *)mainReleases
{
    if (_mainReleases!=mainReleases)
    {
        _mainReleases = [mainReleases mutableCopy];
    }
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setOtherMasters:(NSMutableArray *)otherMasters
{
    if (_otherMasters!=otherMasters)
    {
        _otherMasters = [otherMasters mutableCopy];
    }
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setOtherReleases:(NSMutableArray *)otherReleases
{
    if (_otherReleases!=otherReleases)
    {
        _otherReleases = [otherReleases mutableCopy];
    }
}

/*
 * Μέθοδος που καλείται κατα τη φόρτωση του ελεγκτή στη μνήμη. Ορισμός του τίτλου στο Navigation Panel.
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.artistName;
}

/*
 * Μέθοδος που καλείται όταν η συσκευή δώσει σήμα ειδοποίησης για γέμισμα της μνήμης.
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * Μέθοδος που συνεχίζει τη φόρτωση των αποτελεσμάτων απο τις σελίδες
 */

-(void)continueFetch:(NSString *)next
{
    concurrentFetchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentFetchQueue, ^{
        if (next)
        {
            self.stopFetch = NO;
            NSArray *fetch;
            self.next = next;
            do {
                fetch = [JsonParser threePageFetch:self.next stopFetch:self.stopFetch];
                self.next = [fetch lastObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",self.next);
                });
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:fetch];
                [tmp removeLastObject];
                fetch = [NSArray arrayWithArray:tmp];
                for (NSData *arrayData in fetch)
                {
                    NSArray *releasesResult = [JsonParser jsonArrayFromData:@"releases" data:arrayData];
                    [self.masters addObjectsFromArray:[DataController mastersFromJson:releasesResult]];
                    [self.releases addObjectsFromArray:[DataController releasesFromJson:releasesResult]];
                    for (Master *mast in [DataController mastersFromJson:releasesResult]) {
                        if ([mast.role isEqualToString:@"Main"]) {
                            [self.mainMasters addObject:mast];
                        }
                        else
                        {
                            [self.otherMasters addObject:mast];
                        }
                    }
                    for (Release *rel in [DataController releasesFromJson:releasesResult]) {
                        if ([rel.role isEqualToString:@"Main"]) {
                            [self.mainReleases addObject:rel];
                        }
                        else
                        {
                            [self.otherReleases addObject:rel];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    NSLog(@"reload data table: %d",[self.tableView numberOfRowsInSection:0]);
                });
            } while (![self.next isEqualToString:@"nonext"] && self.stopFetch == NO);
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

#pragma mark - Table view data source

/*
 * Μέθοδος που καλείται κατα την κατασκευή του πίνακα. Επιστρέφει τον τίτλο της κεφαλίδας για κάθε κατηγορία του πίνακα.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return @"Master Releases";
    }
    else if (section==1)
    {
        return @"Releases";
    }
    else
    {
        return nil;
    }
}

/*
 * Μέθοδος που επιστρέφει το πλήθος των κεφαλίδων του πίνακα.
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.masters && self.releases)
    {
        return 2;
    }
    else if (self.masters || self.releases)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

/*
 * Μέθοδος που επιστρέφει το πλήθος των γραμμών του πίνακα ανα κατηγορία.
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.flag isEqualToString:@"all"])
    {
        if (section==0)
        {
            return self.masters.count;
        }
        else if (section==1)
        {
            return self.releases.count;
        }
        else
        {
            return 0;
        }
    }
    else if ([self.flag isEqualToString:@"main"])
    {
        if (section==0)
        {
            return self.mainMasters.count;
        }
        else if (section==1)
        {
            return self.mainReleases.count;
        }
        else
        {
            return 0;
        }
    }
    else if ([self.flag isEqualToString:@"other"])
    {
        if (section==0)
        {
            return self.otherMasters.count;
        }
        else if (section==1)
        {
            return self.otherReleases.count;
        }
        else
        {
            return 0;
        }
    }
    return 0;
}

/*
 * Μέθοδος που επιστρέφει το κελί για κάθε γραμμή του πίνακα ανα κατηγορία.
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSInteger section = [indexPath section];
    if ([self.flag isEqualToString:@"all"])
    {
        if (section == 1)
        {
            [cell.textLabel setText:[[[self releases] objectAtIndex:indexPath.row] title]];
        }
        if (section == 0)
        {
            [cell.textLabel setText:[[[self masters] objectAtIndex:indexPath.row] title]];
        }
    }
    else if ([self.flag isEqualToString:@"main"])
    {
        if (section == 1)
        {
            [cell.textLabel setText:[[[self mainReleases] objectAtIndex:indexPath.row] title]];
        }
        if (section == 0)
        {
            [cell.textLabel setText:[[[self mainMasters] objectAtIndex:indexPath.row] title]];
        }
    }
    else if ([self.flag isEqualToString:@"other"])
    {
        if (section == 1)
        {
            [cell.textLabel setText:[[[self otherReleases] objectAtIndex:indexPath.row] title]];
        }
        if (section == 0)
        {
            [cell.textLabel setText:[[[self otherMasters] objectAtIndex:indexPath.row] title]];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

/*
 * Μέθοδος που καλείται όταν η επιλεχθεί κάποιο κελί απο τον πίνακα.
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    if ([self.flag isEqualToString:@"all"])
    {
        if (indexPath.section == 0)
        {
            [self performSegueWithIdentifier:@"MasterInfo" sender:[self.masters objectAtIndex:indexPath.row]];
        }
        else if (indexPath.section == 1)
        {
            [self performSegueWithIdentifier:@"ReleaseInfo" sender:[self.releases objectAtIndex:indexPath.row]];
        }
    }
    else if ([self.flag isEqualToString:@"main"])
    {
        if (indexPath.section == 0)
        {
            [self performSegueWithIdentifier:@"MasterInfo" sender:[self.mainMasters objectAtIndex:indexPath.row]];
        }
        else if (indexPath.section == 1)
        {
            [self performSegueWithIdentifier:@"ReleaseInfo" sender:[self.mainReleases objectAtIndex:indexPath.row]];
        }
    }
    else if ([self.flag isEqualToString:@"other"])
    {
        if (indexPath.section == 0)
        {
            [self performSegueWithIdentifier:@"MasterInfo" sender:[self.otherMasters objectAtIndex:indexPath.row]];
        }
        else if (indexPath.section == 1)
        {
            [self performSegueWithIdentifier:@"ReleaseInfo" sender:[self.otherReleases objectAtIndex:indexPath.row]];
        }
    }
}

/*
 * Μέθοδος προετοιμασίας αλλαγής οθόνης. Ανάθεση ελεγκτή και απαραίτητων παραμέτρων.
 */

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        if ([[segue identifier] isEqualToString:@"MasterInfo"])
        {
            MasterVersionsViewController *mVVC = [segue destinationViewController];
            [mVVC setMaster:sender];
            [mVVC.master setArtist:self.artistName];
            [mVVC.master makeVersionsURL];
            NSData *data = [NSData dataWithContentsOfURL:mVVC.master.versionsURL];
            NSArray *versions = [JsonParser jsonArrayFromData:@"versions" data:data];
            mVVC.releases = [[NSMutableArray alloc] initWithCapacity:[versions count]];
            [mVVC setReleases:[DataController versionsFromJson:versions]];
            data = [NSData dataWithContentsOfURL:mVVC.master.resourceURL];
            NSArray *genres = [JsonParser jsonArrayFromData:@"genres" data:data];
            NSMutableString *res = [[NSMutableString alloc] init];
            NSArray *artist = [JsonParser jsonArrayFromData:@"artists" data:data];
            NSString *result;
            for (NSDictionary *dic in artist) {
                if ([dic objectForKey:@"name"]) {
                    result = [NSString stringWithString:[dic objectForKey:@"name"]];
                }
            }
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
                
                mVVC.displayTitle = [NSString stringWithFormat:@"%@ - %@",result,[sender title]];
                [SVProgressHUD dismiss];
                [mVVC.tableView reloadData];
            });
        }
        if ([[segue identifier] isEqualToString:@"ReleaseInfo"])
        {
            ReleaseDetailsViewController *rDVC = [segue destinationViewController];
            [rDVC setTheRelease:sender];
            NSData *data = [NSData dataWithContentsOfURL:rDVC.theRelease.resourceURL];
            NSArray *images = [JsonParser jsonArrayFromData:@"images" data:data];
            [rDVC setImages:images];
            rDVC.primaryImage = [NSURL URLWithString:[DataController primaryImage150FromJson:images]];
            [rDVC.mainImage setImage:rDVC.theRelease.primaryImage];
            NSArray *tracklistArray = [JsonParser jsonArrayFromData:@"tracklist" data:data];
            rDVC.theRelease.tracklist = [[NSMutableArray alloc] init];
            NSArray *artist = [JsonParser jsonArrayFromData:@"artists" data:data];
            NSString *result;
            for (NSDictionary *dic in artist) {
                if ([dic objectForKey:@"name"]) {
                    result = [NSString stringWithString:[dic objectForKey:@"name"]];
                }
            }
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
                rDVC.releaseLabel.text = [NSString stringWithFormat:@"%@ - %@",result,[sender title]];
                [rDVC.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        }
    });
}

/*
 * Μέθοδος που καλείται όταν αποφορτωθεί ο ελεγκτής απο τη μνήμη.
 */

-(void)viewDidDisappear:(BOOL)animated
{
    self.stopFetch = YES;
    dispatch_suspend(concurrentFetchQueue);
}

/*
 * Μέθοδος που καλείται όταν επιλεχθεί το κουμπί των ρόλων. Εμφάνιση του επιλογέα ρόλων (All Roles, Main Roles, Other Roles)
 */

- (IBAction)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose a role to display:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"All roles",@"Main roles",@"Other roles", nil];
    [actionSheet showInView:self.view];
}

/*
 * Μέθοδος που καλείται όταν επιλεχθεί κάποιος ρόλος, ενημέρωση πίνακα ανάλογα με την επιλογή.
 */

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"All roles"])
    {
        self.flag = @"all";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.roleButton.title = @"All Roles";
    }
    else if ([buttonTitle isEqualToString:@"Main roles"])
    {
        self.flag = @"main";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.roleButton.title = @"Main Roles";
    }
    else if ([buttonTitle isEqualToString:@"Other roles"])
    {
        self.flag = @"other";
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.roleButton.title = @"Other Roles";
    }
}

@end