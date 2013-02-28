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
	// Do any additional setup after loading the view.
}

-(void)loadDescription
{
    if (self.artist)
    {
        //NSLog(@"resource: %@", self.artist.resourceURL);
        NSData *data = [NSData dataWithContentsOfURL:self.artist.resourceURL];
        NSArray *profile = [JsonParser jsonArrayFromData:@"profile" :data];
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
        NSLog(@"opa");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setArtistName:nil];
    [self setDescriptionText:nil];
    [super viewDidUnload];
}

@end