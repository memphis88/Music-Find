//
//  jsonParser.m
//  Music Find
//
//  Created by Memphis on 11/6/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "JsonParser.h"
#import "SVProgressHUD.h"

@implementation JsonParser

+ (NSString *)jsonValueFromData:(NSString *)key :(NSData *)data
{
    if (data)
    {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error==nil)
        {
            NSString *res = [json objectForKey:key];
            //NSLog(@"results: %@" , res);
            if (res)
            {
                return res;
            }
            else
            {
                NSLog(@"error no value for key:%@" , key);
                return nil;
            }
        }
        else
        {
            NSLog(@"error in serialize %@", error);
            return nil;
        }
    }
    else
    {
        NSLog(@"no data");
        return nil;
    }
}

+ (NSArray *)jsonArrayFromData:(NSString *)key :(NSData *)data
{
    if (data)
    {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error)
        {
            NSLog(@"error: %@" , error);
            return nil;
        }
        else
        {
            NSArray *arr = [json objectForKey:key];
            return arr;
        }
    }
    else
    {
        NSLog(@"no data");
        return nil;
    }
}

+(BOOL)paginationCheck:(NSData *)data
{
    if (data)
    {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error)
        {
            NSLog(@"error: %@" , error);
        }
        else
        {
            NSArray *arr = [json objectForKey:@"pagination"];
            if ([[arr valueForKey:@"pages"] intValue] > 1)
            {
                return YES;
            }
        }
    }
    else
    {
        NSLog(@"no data");
    }
    return NO;
}

+(NSArray *)pagesFromData:(NSData *)data
{
    if (data)
    {
        NSMutableArray *res = [[NSMutableArray alloc] init];
        NSError *error = nil;
        NSDictionary *json;
        NSDictionary *urls;
        NSDictionary *dic;
        NSURL *next;
        NSString *check;
        NSString *loading;
        do
        {
            json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error)
            {
                NSLog(@"error: %@", error);
            }
            else
            {
                [res addObject:data];
                dic = [json objectForKey:@"pagination"];
                loading = [NSString stringWithFormat:@"Loading...\nPage: %@ of %@",[dic objectForKey:@"page"],[dic objectForKey:@"pages"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:loading maskType:SVProgressHUDMaskTypeBlack];
                });
                urls = [dic objectForKey:@"urls"];
                next = [NSURL URLWithString:[urls objectForKey:@"next"]];
                data = [NSData dataWithContentsOfURL:next];
                check = [[dic objectForKey:@"urls"] objectForKey:@"next"];
            }
        } while (check!=nil);
        NSLog(@"pages:%d",[res count]+1);
        return [NSArray arrayWithArray:res];
    }
    else
    {
        NSLog(@"no data");
    }
    return nil;
}

+(NSArray *)moreThanFive:(NSData *)data
{
    if (data)
    {
        NSMutableArray *res = [[NSMutableArray alloc] init];
        NSError *error = nil;
        NSDictionary *json;
        NSDictionary *urls;
        NSDictionary *dic;
        NSURL *next;
        NSString *loading;
        for (int i=1; i<=5; i++)
        {
            json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error)
            {
                NSLog(@"error: %@", error);
            }
            else
            {
                [res addObject:data];
                dic = [json objectForKey:@"pagination"];
                loading = [NSString stringWithFormat:@"Loading...\nPage: %@ of %@\nShowing the 5 first pages",[dic objectForKey:@"page"],[dic objectForKey:@"pages"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:loading maskType:SVProgressHUDMaskTypeBlack];
                });
                urls = [dic objectForKey:@"urls"];
                next = [NSURL URLWithString:[urls objectForKey:@"next"]];
                data = [NSData dataWithContentsOfURL:next];
            }
            if (i==5)
            {
                [res addObject:[urls valueForKey:@"next"]];
            }
        }
        return [NSArray arrayWithArray:res];
    }
    return nil;
}

+(NSArray *)threePageFetch:(NSString *)next stopFetch:(BOOL)stop
{
    if (next)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        NSURL *nexturl = [NSURL URLWithString:next];
        NSData *data = [NSData dataWithContentsOfURL:nexturl];
        NSMutableArray *res = [[NSMutableArray alloc] init];
        NSError *error = nil;
        NSDictionary *json;
        NSDictionary *urls;
        NSDictionary *dic;
        if (data)
        {
            for (int i=0; i<3; i++)
            {
                if (stop ==  YES)
                {
                    break;
                }
                json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error)
                {
                    NSLog(@"error: %@", error);
                }
                else
                {
                    [res addObject:data];
                    dic = [json objectForKey:@"pagination"];
                    urls = [dic objectForKey:@"urls"];
                    nexturl = [NSURL URLWithString:[urls objectForKey:@"next"]];
                    if (nexturl)
                    {
                        if (i==2)
                        {
                            [res addObject:[urls valueForKey:@"next"]];
                        }
                        data = [NSData dataWithContentsOfURL:nexturl];
                    }
                    else
                    {
                        [res addObject:@"nonext"];
                        break;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            return [NSArray arrayWithArray:res];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    return nil;
}

@end
