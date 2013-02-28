//
//  Requester.m
//  Music Find
//
//  Created by Memphis on 10/27/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "Requester.h"
#import "GTMOAuthAuthentication.h"
#import "GTMOAuthViewControllerTouch.h"
@implementation Requester

- (IBAction)signInButton:(id)sender
{
    [self signInToCustomService];
}

- (GTMOAuthAuthentication *)myCustomAuth
{
    NSString *myConsumerKey = @"KKIyeEbGSQaPfJajOxUz";    // pre-registered with service
    NSString *myConsumerSecret = @"kWCqYJzxGtRPgIDKgZgcqxxdKdqmqvHC"; // pre-assigned by service
    
    GTMOAuthAuthentication *auth;
    auth = [[[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                        consumerKey:myConsumerKey
                                                         privateKey:myConsumerSecret] autorelease];
    
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
    viewController = [[[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                                language:nil
                                                         requestTokenURL:requestURL
                                                       authorizeTokenURL:authorizeURL
                                                          accessTokenURL:accessURL
                                                          authentication:auth
                                                          appServiceName:@"MF: request token"
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];
    [viewController setBrowserCookiesURL:[NSURL URLWithString:@"http://www.discogs.com/"]];
    [[self navigationController] pushViewController:viewController
                                           animated:YES];
}
- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error
{
    if (error != nil) {
        // Authentication failed
        NSLog(@"blabla");
    } else {
        // Authentication succeeded
        NSLog(@"no blabla");
    }
}

-(id)init
{
    self.initialHTMLString = @"Loading";
    [super init];
    return self;
}

@end
