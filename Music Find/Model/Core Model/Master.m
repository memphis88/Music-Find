//
//  Master.m
//  Music Find
//
//  Created by Memphis on 12/4/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "Master.h"
#import "JsonParser.h"

@implementation Master

@synthesize title = _title, resourceURL = _resourceURL, idNumber = _idNumber, tracklist = _tracklist;

/*
 * Κατασκευαστής.
 */

-(id)initWithStats:(NSString *)title resourceURL:(NSURL *)resourceURL idNum:(int)idNumber
{
    self = [super init];
    if (self)
    {
        _title = title;
        _resourceURL = resourceURL;
        _idNumber = idNumber;
        return self;
    }
    return nil;
}

/*
 * Φόρτωση υπερσυνδέσμου ανακατεύθηνσης στις εκδόσεις της κυκλοφορίας.
 */

-(void)makeVersionsURL
{
    NSData *data = [NSData dataWithContentsOfURL:self.resourceURL];
    _versionsURL = [NSURL URLWithString:[JsonParser jsonValueFromData:@"versions_url" data:data]];
    
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

@end
