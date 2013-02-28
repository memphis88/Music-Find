//
//  logInViewController.m
//  Music Find
//
//  Created by Memphis on 10/31/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "LogInViewController.h"
#import "GTMOAuthViewControllerTouch.h"
#import "GTMOAuthAuthentication.h"
#import "searchViewController.h"
@interface LogInViewController ()

@end

@class GTMOAuthAuthentication;

@implementation LogInViewController

@synthesize accessToken = _accessToken;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GTMOAuthAuthentication *)myCustomAuth
{
    NSString *myConsumerKey = @"KKIyeEbGSQaPfJajOxUz";    // pre-registered with service
    NSString *myConsumerSecret = @"kWCqYJzxGtRPgIDKgZgcqxxdKdqmqvHC"; // pre-assigned by service
    
    GTMOAuthAuthentication *auth;
    auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                        consumerKey:myConsumerKey
                                                         privateKey:myConsumerSecret];
    
    // setting the service name lets us inspect the auth object later to know
    // what service it is for
    auth.serviceProvider = @"MF authenticate request";
    
    return auth;
}

- (void)signInToCustomService
{
    
    NSURL *requestURL = [NSURL URLWithString:@"http://api.discogs.com/oauth/request_token"];
    NSURL *accessURL = [NSURL URLWithString:@"http://api.discogs.com/oauth/access_token"];
    NSURL *authorizeURL = [NSURL URLWithString:@"http://www.discogs.com/oauth/authorize"];
    NSString *scope = @"http://api.discogs.com";
    
    GTMOAuthAuthentication *auth = [self myCustomAuth];
    
    // set the callback URL to which the site should redirect, and for which
    // the OAuth controller should look to determine when sign-in has
    // finished or been canceled
    //
    // This URL does not need to be for an actual web page
    [auth setCallback:@"http://www.example.com/OAuthCallback"];
    
    // Display the autentication view
    GTMOAuthViewControllerTouch *viewController;
    viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                                language:nil
                                                         requestTokenURL:requestURL
                                                       authorizeTokenURL:authorizeURL
                                                          accessTokenURL:accessURL
                                                          authentication:auth
                                                          appServiceName:@"MF: request token"
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [viewController setBrowserCookiesURL:[NSURL URLWithString:@"http://www.discogs.com/"]];
    [[self navigationController] pushViewController:viewController
                                           animated:YES];
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error
{
    if (error != nil)
    {
        // Authentication failed
        NSLog(@"can't login, error: %@", error);
        [self.spin stopAnimating];
        [self.welcomeLabel setText:@"Login has failed."];
    }
    else
    {
        // Authentication succeeded
        NSLog(@"Access Token: %@", auth.accessToken);
        _accessToken = auth.accessToken;
        [self setMAuth:auth];
        [self.signIn setHidden:TRUE];
        [self.spin stopAnimating];
        [self.welcomeLabel setText:@"Successful login!"];
        [self performSegueWithIdentifier:@"successfulSignIn" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"successfulSignIn"])
    {
        SearchViewController *sVC = [segue destinationViewController];
        //[sVC setAuth:[self mAuth]];
    }
}

- (BOOL)isSignedIn
{
    BOOL isSignedIn = self.mAuth.canAuthorize;
    return isSignedIn;
}

-(void)signIntoDiscogs:(id)sender
{
    [self signInToCustomService];
    [self.spin startAnimating];
}
- (void)viewDidUnload {
    [self setSpin:nil];
    [self setWelcomeLabel:nil];
    [super viewDidUnload];
}
@end
