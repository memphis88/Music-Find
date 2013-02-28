//
//  ReleaseDetailedViewController.h
//  Music Find
//
//  Created by Memphis on 12/7/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Master,Release;

@interface ReleaseDetailedViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tapForImages;
@property (nonatomic, strong) Release *theRelease;
@property (strong, nonatomic) NSURL *primaryImage;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;

- (IBAction)searchMarket:(id)sender;
- (void)moreImages;
- (void)parseDidComplete:(NSMutableString *)result;
- (void)parseInMidle:(NSMutableArray *)result;
- (void)updateUI;

@end
