//
//  ArtistReleasesViewController.h
//  Music Find
//
//  Created by Memphis on 12/5/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistReleasesViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, copy) NSMutableArray *releases;
@property (nonatomic, copy) NSMutableArray *masters;
@property (nonatomic, copy) NSMutableArray *mainMasters;
@property (nonatomic, copy) NSMutableArray *mainReleases;
@property (nonatomic, copy) NSMutableArray *otherMasters;
@property (nonatomic, copy) NSMutableArray *otherReleases;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *flag;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *roleButton;
@property (nonatomic) BOOL stopFetch;
@property (weak, nonatomic) NSString *next;

- (IBAction)showActionSheet:(id)sender;
- (void)continueFetch:(NSString *)next;

@end
