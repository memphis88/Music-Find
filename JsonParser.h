//
//  jsonParser.h
//  Music Find
//
//  Created by Memphis on 11/6/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

+ (NSString *)jsonValueFromData:(NSString *)key :(NSData *)data;
+ (NSArray *)jsonArrayFromData:(NSString *)key :(NSData *)data;
+ (BOOL)paginationCheck:(NSData *)data;
+ (NSArray *)pagesFromData:(NSData *)data;
+ (NSArray *)moreThanTen:(NSData *)data;
+ (NSArray *)tenPageFetch:(NSString *)next;

@end
