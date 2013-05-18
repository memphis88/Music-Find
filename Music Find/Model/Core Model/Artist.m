//
//  Artist.m
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "Artist.h"

@implementation Artist
@synthesize name = _name, resourceURL = _resourceURL, idNumber = _idNumber, profile = _profile, releasesURL = _releasesURL;

-(id)initWithStats:(NSString *)title resourceURL:(NSURL *)resourceURL idNum:(int)idNumber
{
    self = [super init];
    if (self)
    {
        _name = title;
        _resourceURL = resourceURL;
        _idNumber = idNumber;
        return self;
    }
    return nil;
}

-(void)returnAllStats
{
    NSLog(@"artist name: %@\nresource: %@ \nid: %d", [self name], [self resourceURL], [self idNumber]);
}

@end
