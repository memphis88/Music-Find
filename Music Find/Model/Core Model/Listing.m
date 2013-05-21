//
//  Listing.m
//  Music Find
//
//  Created by Memphis on 12/12/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "Listing.h"
#import "JsonParser.h"

@implementation Listing

@synthesize price = _price, sleeveCondition = _sleeveCondition, condition = _condition, comments = _comments, ships = _ships, resourceURL = _resourceURL;

/*
 * Κατασκευαστής.
 */

-(id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        _resourceURL = url;
        return self;
    }
    return nil;
}

/*
 * Μέθοδος φόρτωσης δεδομένων της αγγελίας. Παραμετροποίηση τιμών.
 */

-(void)makeListing
{
    NSData *data = [NSData dataWithContentsOfURL:_resourceURL];
    _sleeveCondition = [JsonParser jsonValueFromData:@"sleeve_condition" data:data];
    _condition = [JsonParser jsonValueFromData:@"condition" data:data];
    _comments = [JsonParser jsonValueFromData:@"comments" data:data];
    _ships = [JsonParser jsonValueFromData:@"ships_from" data:data];
    NSArray *arr = [JsonParser jsonArrayFromData:@"seller" data:data];
    _seller = [(NSDictionary *)arr objectForKey:@"username"];
    NSArray *priceArr = [JsonParser jsonArrayFromData:@"price" data:data];
    NSString *tmp;
    if ([[(NSDictionary *)priceArr objectForKey:@"currency"] isEqualToString:@"EUR"])
    {
        tmp = @"€";
    }
    else if ([[(NSDictionary *)priceArr objectForKey:@"currency"] isEqualToString:@"USD"])
    {
        tmp = @"$";
    }
    else if ([[(NSDictionary *)priceArr objectForKey:@"currency"] isEqualToString:@"GBP"])
    {
        tmp = @"£";
    }
    else
    {
        tmp = [(NSDictionary *)priceArr objectForKey:@"currency"];
    }
    _price = [NSString stringWithFormat:@"%@ %@",[(NSDictionary *)priceArr objectForKey:@"value"],tmp];
    _URI = [NSURL URLWithString:[JsonParser jsonValueFromData:@"uri" data:data]];
}

/*
 * Μέθοδος debugging.
 */

-(void)returnAllStats
{
    NSLog(@"%@%@%@%@%@%@",_sleeveCondition,_condition,_comments,_seller,_price,_ships);
}

@end
