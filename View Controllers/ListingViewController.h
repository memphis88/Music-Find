//
//  ListingViewController.h
//  Music Find
//
//  Created by Memphis on 12/13/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Listing, Release;

@interface ListingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *releaseImage;
@property (weak, nonatomic) IBOutlet UILabel *artistRelease;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *genre;
@property (weak, nonatomic) IBOutlet UILabel *seller;
@property (weak, nonatomic) IBOutlet UILabel *condition;
@property (weak, nonatomic) IBOutlet UILabel *sleeveCondition;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (weak, nonatomic) IBOutlet UILabel *shipsFrom;
@property (weak, nonatomic) IBOutlet UIButton *discogsButton;
@property (nonatomic, strong) Release *theRelease;
@property (nonatomic, strong) Listing *theListing;

- (IBAction)viewInDiscogs:(id)sender;

@end
