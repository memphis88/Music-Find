//
//  DescriptionViewController.m
//  Music Find
//
//  Created by Memphis on 11/28/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "DescriptionViewController.h"
#import "JsonParser.h"
#import "Artist.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController
@synthesize artist = _artist;

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
 * Μέθοδος που καλείται κατα τη φόρτωση του ελεγκτή στη μνήμη.
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.backBarButtonItem.width = 60;
}

/*
 * Μέθοδος φορτώνει την περιγραφή του καλλιτέχνη, εφόσον υπάρχει, στην περιοχή κειμένου.
 */

-(void)loadDescription
{
    if (self.artist)
    {
        //NSLog(@"resource: %@", self.artist.resourceURL);
        NSData *data = [NSData dataWithContentsOfURL:self.artist.resourceURL];
        NSArray *profile = [JsonParser jsonArrayFromData:@"profile" data:data];
        //NSLog(@"profile: %@", profile);
        if (profile)
        {
            self.artist.description = (NSString *)profile;
        }
        else
        {
            self.artist.description = @"No description available.";
        }
    }
    else
    {
        NSLog(@"error");
    }
}

/*
 * Μέθοδος που καλείται όταν η συσκευή δώσει σήμα ειδοποίησης για γέμισμα της μνήμης.
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * Μέθοδος που καλείται όταν αποφορτωθεί ο ελεγκτής απο τη μνήμη.
 */

- (void)viewDidUnload
{
    [self setArtistName:nil];
    [self setDescriptionText:nil];
    [super viewDidUnload];
}

@end