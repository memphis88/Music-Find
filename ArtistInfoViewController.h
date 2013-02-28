//
//  ArtistInfoViewController.h
//  Music Find
//
//  Created by Memphis on 11/26/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Artist, ArtistReleasesViewController;

@interface ArtistInfoViewController : UITableViewController

@property (nonatomic, strong) Artist *artist;
@property (weak, nonatomic) IBOutlet UIImageView *artistThumb;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UITableViewCell *linksCell;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;

-(void)loadImageFromURL:(NSData *)data;

@end
