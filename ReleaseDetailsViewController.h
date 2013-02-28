//
//  ReleaseDetailsViewController.h
//  Music Find
//
//  Created by Memphis on 1/9/13.
//  Copyright (c) 2013 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Release;

@interface ReleaseDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Release *theRelease;
@property (strong, nonatomic) NSURL *primaryImage;
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *tapForImages;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

- (IBAction)searchMarket:(id)sender;
- (void)moreImages;
- (void)parseIDs:(NSMutableString *)result;
- (void)parseTitles:(NSMutableArray *)result;
- (void)updateUI;


@end
