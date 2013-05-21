//
//  ArtistLinksViewController.m
//  Music Find
//
//  Created by Memphis on 12/6/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "ArtistLinksViewController.h"

@interface ArtistLinksViewController ()

@end

@implementation ArtistLinksViewController

@synthesize artistName = _artistName, links = _links;

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
 * Μέθοδος που καλείται κατα τη φόρτωση του ελεγκτή στη μνήμη.
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return self.links.count;
}

/*
 * Μέθοδος που επιστρέφει το κελί για κάθε γραμμή του πίνακα ανα κατηγορία.
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.links objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

/*
 * Μέθοδος που καλείται όταν η επιλεχθεί κάποιο κελί απο τον πίνακα.
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.links objectAtIndex:indexPath.row]]];
}

@end
