//
//  Requester.h
//  Music Find
//
//  Created by Memphis on 10/27/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "GTMOAuthViewControllerTouch.h"
#import <Foundation/Foundation.h>
@class GTMOAuthAuthentication;
@interface Requester : GTMOAuthViewControllerTouch
//@property NSString * outputString;
//-(NSUInteger)makeRequest:(NSString *) query;
- (IBAction)signInButton:(id)sender;
- (GTMOAuthAuthentication *)myCustomAuth;
- (void)signInToCustomService;
@end
