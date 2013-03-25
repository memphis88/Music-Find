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
    self.seller.text = self.theListing.seller;
    self.condition.text = self.theListing.condition;
    self.sleeveCondition.text = self.theListing.sleeveCondition;
    self.price.text = self.theListing.price;
    self.shipsFrom.text = self.theListing.ships;
    if ([self.theListing.comments length]==0)
    {
        self.commentLabel.hidden = YES;
        self.comments.hidden = YES;
        self.discogsButton.center = CGPointMake(self.scrollView.center.x+15, self.sleeveCondition.center.y + 52);
    }
    else
    {
        self.comments.text = self.theListing.comments;
        CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
        
        CGSize expectedLabelSize = [self.comments.text sizeWithFont:self.comments.font constrainedToSize:maximumLabelSize lineBreakMode:self.comments.lineBreakMode];
        
        //adjust the label the the new height.
        CGRect newFrame = self.comments.frame;
        newFrame.size.height = expectedLabelSize.height;
        self.comments.frame = newFrame;
        self.discogsButton.center = CGPointMake(self.scrollView.center.x+15, (self.comments.frame.size.height + self.comments.frame.origin.y) + 52);
    }
    self.artistRelease.text = self.theListing.displayTitle;
	self.label.text = self.theRelease.label;
    self.genre.text = self.theRelease.genre;
    self.releaseImage.image = self.theRelease.primaryImage;
    self.scrollView.contentSize = CGSizeMake(320, (self.discogsButton.frame.origin.y + self.discogsButton.frame.size.height) + 50);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
