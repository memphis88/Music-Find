//
//  Release.m
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "Release.h"

@implementation Release

@synthesize title = _title, resourceURL = _resourceURL, idNumber = _idNumber;

-(id)initWithStats:(NSString *)title resourceURL:(NSURL *)resourceURL idNum:(int)idNumber format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        _title = title;
        _resourceURL = resourceURL;
        _idNumber = idNumber;
        _format = format;
        return self;
    }
    return nil;
}

-(void)returnAllStats
{
    NSLog(@"release title: %@\nresource: %@ \nid: %d", [self title], [self resourceURL], [self idNumber]);
}

-(void)setTracklist:(NSMutableArray *)tracklist
{
    if (_tracklist != tracklist)
    {
        _tracklist = [tracklist mutableCopy];
    }
}

-(void)setListings:(NSMutableArray *)listings
{
    if (_listings != listings)
    {
        _listings = [listings mutableCopy];
    }
}

-(void)setListingTitles:(NSMutableArray *)listingTitles
{
    if (_listingTitles != listingTitles)
    {
        _listingTitles = [listingTitles mutableCopy];
    }
}

@end
