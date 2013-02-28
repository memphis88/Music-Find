//
//  logInViewController.h
//  Music Find
//
//  Created by Memphis on 10/31/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTMOAuthAuthentication;
@interface LogInViewController : UIViewController

@property (weak, nonatomic) NSString *accessToken;
@property (weak, nonatomic) GTMOAuthAuthentication *mAuth;
@property (weak, nonatomic) IBOutlet UIButton *signIn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spin;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

- (void)signInToCustomService;
- (GTMOAuthAuthentication *)myCustomAuth;
- (IBAction)signIntoDiscogs:(id)sender;
- (BOOL)isSignedIn;

@end
