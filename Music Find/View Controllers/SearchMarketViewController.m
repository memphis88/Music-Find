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
 * Μέθοδος που καλείται κατα τη φόρτωση του ελεγκτή στη μνήμη. Δημιουργία αντικειμένου Listing για φόρτωση των αγγελιών.
 */

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
}

/*
 * Μέθοδος που καλείται όταν η συσκευή δώσει σήμα ειδοποίησης για γέμισμα της μνήμης.
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
 * Μέθοδος που επιστρέφει το πλήθος των κεφαλίδων του πίνακα.
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/*
 * Μέθοδος που επιστρέφει το πλήθος των γραμμών του πίνακα ανα κατηγορία.
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.listings.count - 1;
}

/*
 * Μέθοδος που επιστρέφει το κελί για κάθε γραμμή του πίνακα ανα κατηγορία.
 */

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

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setListingsTitles:(NSArray *)listingsTitles
{
    if (_listingsTitles!=listingsTitles)
    {
        _listingsTitles = [listingsTitles mutableCopy];
    }
}

#pragma mark - Table view delegate

/*
 * Μέθοδος που καλείται όταν η επιλεχθεί κάποιο κελί απο τον πίνακα.
 */

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

/*
 * Μέθοδος προετοιμασίας αλλαγής οθόνης. Ανάθεση ελεγκτή και απαραίτητων παραμέτρων.
 */

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

/*
 * Μέθοδος που καλείται όταν αποφορτωθεί ο ελεγκτής απο τη μνήμη.
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
