//
//  searchViewController.h
//  Music Find
//
//  Created by Memphis on 11/2/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTMOAuthAuthentication, DataController;
 
@interface SearchViewController : UIViewController <UISearchBarDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *queryText;
//@property (strong, nonatomic) GTMOAuthAuthentication *auth;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (nonatomic, strong) DataController *dataC;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentType;
@property (nonatomic) BOOL internetActive;
@property (nonatomic) BOOL hostActive;

- (IBAction)searchString:(id)sender;
-(void)parallelAction;
-(void)checkNetworkStatus:(NSNotification *)notice;

@end
