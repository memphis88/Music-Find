//
//  ListingViewController.m
//  Music Find
//
//  Created by Memphis on 12/13/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "ListingViewController.h"
#import "Listing.h"
#import "Release.h"

@interface ListingViewController ()

@end

@implementation ListingViewController

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
    self.seller.text = [NSString stringWithFormat:@"Seller: %@",self.theListing.seller];
    //[self.seller sizeToFit];
    self.condition.text = [NSString stringWithFormat:@"Condition: %@",self.theListing.condition];
    //[self.condition sizeToFit];
    self.sleeveCondition.text = [NSString stringWithFormat:@"Sleeve Condition: %@",self.theListing.sleeveCondition];
    //[self.sleeveCondition sizeToFit];
    self.price.text = [NSString stringWithFormat:@"Price: %@",self.theListing.price];
    self.shipsFrom.text = [NSString stringWithFormat:@"Ships from: %@",self.theListing.ships];
    //[self.price sizeToFit];
    if ([self.theListing.comments length]==0)
    {
        self.commentLabel.hidden = YES;
        self.comments.hidden = YES;
        [self.discogsButton setFrame:CGRectMake(78.0, (self.sleeveCondition.frame.origin.y + 21.0), 172.0, 44.0)];
    }
    else
    {
        self.comments.text = self.theListing.comments;
        [self.comments sizeToFit];
    }
    self.artistRelease.text = self.theListing.displayTitle;
    //[self.artistRelease sizeToFit];
	self.label.text = self.theRelease.label;
    //[self.label sizeToFit];
    self.genre.text = self.theRelease.genre;
    //[self.genre sizeToFit];
    self.releaseImage.image = self.theRelease.primaryImage;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setArtistRelease:nil];
    [self setLabel:nil];
    [self setGenre:nil];
    [self setSeller:nil];
    [self setCondition:nil];
    [self setSleeveCondition:nil];
    [self setReleaseImage:nil];
    [self setPrice:nil];
    [self setComments:nil];
    [self setShipsFrom:nil];
    [self setCommentLabel:nil];
    [self setDiscogsButton:nil];
    [super viewDidUnload];
}
- (IBAction)viewInDiscogs:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.theListing.URI];
}
@end
