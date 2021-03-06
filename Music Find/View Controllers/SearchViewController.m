//
//  searchViewController.m
//  Music Find
//
//  Created by Memphis on 11/2/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "SearchViewController.h"
#import "JsonParser.h"
#import "MasterResultTableViewController.h"
#import "DataController.h"
#import "Artist.h"
#import "SVProgressHUD.h"
#import "Reachability.h"

@interface SearchViewController ()
{
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@end

@implementation SearchViewController

/*
 * Κατασκευαστής για τη χρήση αρχείων Nib
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 * Μέθοδος που καλείται κατα τη φόρτωση του ελεγκτή στη μνήμη. Κλήση μεθόδων για τον έλεγχο της κατάστασης του δικτύου.
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    hostReachable = [Reachability reachabilityWithHostName: @"api.discogs.com"];
    [hostReachable startNotifier];
}

/*
 * Μέθοδος που καλείται όταν η συσκευή δώσει σήμα ειδοποίησης για γέμισμα της μνήμης.
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Μέθοδος που καλείται κατα την αποφόρτωση του ελεγκτή απο τη μνήμη.
 */

- (void)viewDidUnload
{
    [self setQueryText:nil];
    [self setSearchLabel:nil];
    [self setSpinner:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

/*
 * Μέθοδος εκκίνησης διαδικασίας αναζήτησης, καλείται κατα το πάτημα του κουμπιού "Search". Κλήση μεθόδου αναζήτησης στο υπόβαθρο.
 */

- (IBAction)searchString:(id)sender
{
    if ([self.queryText.text length] > 0)
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        [self.searchButton setHidden:YES];
        [self performSelectorInBackground:@selector(parallelAction) withObject:nil];
    }
    else
    {
        self.searchLabel.text = @"Please type an argument";
    }
}

/*
 * Μέθοδος που υλοποιεί την αναζήτηση.
 */

-(void)parallelAction
{
    if ([_queryText text])
    {
        [_searchLabel setText:@""];
        NSString *escapedUrlString = [[_queryText text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *tmp = [@"http://api.discogs.com/database/search?q=" stringByAppendingString:escapedUrlString];
        NSMutableString *final;
        switch (_segmentType.selectedSegmentIndex)
        {
            case 0:
                final = [NSString stringWithString:tmp];
                break;
            case 1:
                final = [NSString stringWithFormat:@"%@&type=artist",tmp];
                break;
            case 2:
                final = [NSString stringWithFormat:@"%@&type=master",tmp];
                break;
            case 3:
                final = [NSString stringWithFormat:@"%@&type=release",tmp];
            default:
                break;
        }
        
        NSString *apiSearch = [NSString stringWithFormat:@"%@&per_page=100",final];
        NSURL *url = [NSURL URLWithString:apiSearch];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (![JsonParser paginationCheck:data])
        {
            NSArray *searchResult = [JsonParser jsonArrayFromData:@"results" data:data];
            if ([searchResult count]>0)
            {
                [self setDataC:[[DataController alloc] init]];
                [[self dataC] artistAndReleaseFromJson:searchResult];
                [self performSegueWithIdentifier:@"searchReturned" sender:nil];
            }
            else
            {
                [_searchLabel setText:@"Nothing found."];
                [SVProgressHUD dismiss];
                self.searchButton.hidden = NO;
            }
        }
        else
        {
            //handle search with pagination
            [self setDataC:[[DataController alloc] init]];
            NSArray *pagedJSONData;
            NSString *next;
            if ([[[JsonParser jsonArrayFromData:@"pagination" data:data] valueForKey:@"pages"] integerValue] <= 5)
            {
                pagedJSONData = [JsonParser pagesFromData:data];
            }
            else
            {
                NSArray *tmpArr = [JsonParser moreThanFive:data];
                next = [tmpArr lastObject];
                NSMutableArray *tmpMutArr = [NSMutableArray arrayWithArray:tmpArr];
                [tmpMutArr removeLastObject];
                pagedJSONData = [NSArray arrayWithArray:tmpMutArr];
            }
            for (NSData *arrayData in pagedJSONData)
            {
                NSArray *searchResult = [JsonParser jsonArrayFromData:@"results" data:arrayData];
                [[self dataC] artistAndReleaseFromJson:searchResult];
            }
            [self performSegueWithIdentifier:@"searchReturned" sender:next];
        }
        
    }
}

/*
 * Μέθοδος που καλείται όταν πατηθεί το κουμπί "Search" απο το πληκτρολόγιο της εισαγωγής.
 */

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchString:self];
}

/*
 * Μέθοδος προετοιμασίας αλλαγής οθόνης. Ανάθεση ελεγκτή και απαραίτητων παραμέτρων.
 */

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"searchReturned"])
    {
        UINavigationController *navcon = [segue destinationViewController];
        MasterResultTableViewController *mRTVC = [[navcon viewControllers] objectAtIndex:0];
        mRTVC.dataController = self.dataC;
        if (sender)
        {
            mRTVC.next = sender;
        }
        mRTVC.query = self.queryText.text;
        //[self.spinner stopAnimating];
        [SVProgressHUD dismiss];
        [self.searchButton setHidden:NO];
    }
}

/*
 * Μέθοδος ελέγχου συνδεσημότητας με το διαδύκτιο και τον εξυπηρετητή.
 */

-(void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Connectivity"
                                                              message:@"Cannot reach the internet, please check your connection settings."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }
    }
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Connectivity"
                                                              message:@"Cannot reach Discogs, please check your connection settings or try again later."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
        }
    }
}

/*
 * Μέθοδος που καλείται όταν πατηθεί οποιοδήποτε στοιχείο στην οθόνη που δεν "ακούει" σε κάποιο συμβάν. Σκοπός της μεθόδου είναι να αποσύρει το πληκτρολόγιο εισαγωγής.
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
 * Μέθοδος που καλείται όταν αποφορτωθεί ο ελεγκτής απο τη μνήμη.
 */

-(void)dealloc
{
    [self setDataC:nil];
}

@end
