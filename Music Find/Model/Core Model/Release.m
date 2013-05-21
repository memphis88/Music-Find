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

/*
 * Κατασκευαστής
 */

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

/*
 * Μέθοδος debugging.
 */

-(void)returnAllStats
{
    NSLog(@"release title: %@\nresource: %@ \nid: %d", [self title], [self resourceURL], [self idNumber]);
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setTracklist:(NSMutableArray *)tracklist
{
    if (_tracklist != tracklist)
    {
        _tracklist = [tracklist mutableCopy];
    }
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setListings:(NSMutableArray *)listings
{
    if (_listings != listings)
    {
        _listings = [listings mutableCopy];
    }
}

/*
 * Override του προεπιλεγμένου Setter διότι στην προεπιλογή η αντιγραφή του πίνακα στην ιδιότητα δεν είναι Mutable.
 */

-(void)setListingTitles:(NSMutableArray *)listingTitles
{
    if (_listingTitles != listingTitles)
    {
        _listingTitles = [listingTitles mutableCopy];
    }
}

@end
