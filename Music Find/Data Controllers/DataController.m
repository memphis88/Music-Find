//
//  DataController.m
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "DataController.h"
#import "Artist.h"
#import "Release.h"
#import "Master.h"

@implementation DataController
@synthesize artists = _artists, releases = _releases, masters = _masters;

- (void)artistAndReleaseFromJson:(NSArray *)array
{
    if (array)
    {
        for (int i = 0; i < [array count]; i++)
        {
            NSDictionary *dic = [array objectAtIndex:i];
            if ([[dic objectForKey:@"type"] isEqualToString:@"artist"])
            {
                Artist *art = [[Artist alloc] initWithStats:[dic objectForKey:@"title"] :[NSURL URLWithString:[dic objectForKey:@"resource_url"]] :[[dic objectForKey:@"id"] intValue]];
                art.imageURL = [dic objectForKey:@"thumb"];
                [self.artists addObject:art];
                //NSLog(@"%d",[[self artists] count]);
            }
            else if ([[dic objectForKey:@"type"] isEqualToString:@"release"])
            {
                Release *rel = [[Release alloc] initWithStats:[dic objectForKey:@"title"] :[NSURL URLWithString:[dic objectForKey:@"resource_url"]] :[[dic objectForKey:@"id"] intValue]:[dic objectForKey:@"format"]];
                [self.releases addObject:rel];
            }
            else if ([[dic objectForKey:@"type"] isEqualToString:@"master"])
            {
                Master *mast = [[Master alloc] initWithStats:[dic objectForKey:@"title"] :[NSURL URLWithString:[dic objectForKey:@"resource_url"]] :[[dic objectForKey:@"id"] intValue]];
                [self.masters addObject:mast];
            }
        }
    }
    else
    {
        NSLog(@"nothing found");
    }
}

+ (NSMutableArray *)mastersFromJson:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (array)
    {
        for (int i = 0; i < [array count]; i++)
        {
            NSDictionary *dic = [array objectAtIndex:i];
            if ([[dic objectForKey:@"type"] isEqualToString:@"master"])
            {
                Master *mast = [[Master alloc] initWithStats:[dic objectForKey:@"title"] :[NSURL URLWithString:[dic objectForKey:@"resource_url"]] :[[dic objectForKey:@"id"] intValue]];
                [mast setRole:[dic objectForKey:@"role"]];
                [result addObject:mast];
            }
        }
        return result;
    }
    return nil;
}

+ (NSMutableArray *)releasesFromJson:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (array)
    {
        for (int i = 0; i < [array count]; i++)
        {
            NSDictionary *dic = [array objectAtIndex:i];
            if ([[dic objectForKey:@"type"] isEqualToString:@"release"])
            {
                Release *mast = [[Release alloc] initWithStats:[dic objectForKey:@"title"] :[NSURL URLWithString:[dic objectForKey:@"resource_url"]] :[[dic objectForKey:@"id"] intValue] :[dic objectForKey:@"format"]];
                [mast setRole:[dic objectForKey:@"role"]];
                [result addObject:mast];
            }
        }
        return result;
    }
    return nil;
}

+ (NSString *)primaryImage150FromJson:(NSArray *)array
{
    if (array)
    {
        for (int i = 0; i <[array count]; i++)
        {
            NSDictionary *dic = [array objectAtIndex:i];
            if ([(NSString *)[dic objectForKey:@"type"] isEqualToString:@"primary"])
            {
                return (NSString *)[dic objectForKey:@"uri150"];
            }
        }
        return (NSString *)[[array objectAtIndex:0] objectForKey:@"uri150"];
    }
    else
    {
        return nil;
    }
}

+ (NSMutableArray *)versionsFromJson:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array)
    {
        Release *rel = [[Release alloc] initWithStats:[dic objectForKey:@"title"] :[NSURL URLWithString:[dic objectForKey:@"resource_url"]] :[[dic objectForKey:@"id"] intValue] :[dic objectForKey:@"format"]];
        [rel setLabel:[dic objectForKey:@"label"]];
        [result addObject:rel];
        //NSLog(@"%@",dic);
    }
    return result;
}

+ (NSMutableArray *)returnTrackList:(NSDictionary *)dic
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    if (dic)
    {
        [res addObject:[dic objectForKey:@"position"]];
        [res addObject:[dic objectForKey:@"title"]];
        [res addObject:[dic objectForKey:@"duration"]];
        return res;
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.artists = [[NSMutableArray alloc] init];
        self.releases = [[NSMutableArray alloc] init];
        self.masters = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

-(void)setArtists:(NSMutableArray *)artists
{
    if (_artists != artists)
    {
        _artists = [artists mutableCopy];
    }
}

-(void)setReleases:(NSMutableArray *)releases
{
    if (_releases != releases)
    {
        _releases = [releases mutableCopy];
    }
}
-(void)setMasters:(NSMutableArray *)masters
{
    if (_masters != masters)
    {
        _masters = [masters mutableCopy];
    }
}

-(int)sectionCount
{
    if (([[self artists] count] > 0) && ([[self releases] count]  > 0) && ([[self masters] count] > 0))
    {
        return 3;
    }
    else if ((([self.artists  count] > 0) && ([self.releases count] > 0)) || (([self.releases count] > 0) && ([self.masters count] > 0)) || (([self.artists count] > 0) && ([self.masters count] > 0)))
    {
        return 2;
    }
    else if (([self.artists count] > 0) || ([self.masters count] > 0) || ([self.releases count] > 0))
    {
        return 1;
    }
    return 0;
}

@end
