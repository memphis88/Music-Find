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

-(id)initWithStats:(NSString *)title :(NSURL *)resourceURL :(int)idNumber
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

-(void)makeVersionsURL
{
    NSData *data = [NSData dataWithContentsOfURL:self.resourceURL];
    _versionsURL = [NSURL URLWithString:[JsonParser jsonValueFromData:@"versions_url" :data]];
    
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

@end
