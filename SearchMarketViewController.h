//
//  SearchMarketViewController.h
//  Music Find
//
//  Created by Memphis on 12/12/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Listing, Release;

@interface SearchMarketViewController : UITableViewController

@property (nonatomic, strong) NSArray *listings;
@property (nonatomic, strong) NSArray *listingsTitles;
@property (nonatomic, strong) NSMutableArray *listingsArray;
@property (nonatomic, strong) Release *theRelease;
@end
