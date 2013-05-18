//
//  jsonParser.h
//  Music Find
//
//  Created by Memphis on 11/6/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

+ (NSString *)jsonValueFromData:(NSString *)key data:(NSData *)data;
+ (NSArray *)jsonArrayFromData:(NSString *)key data:(NSData *)data;
+ (BOOL)paginationCheck:(NSData *)data;
+ (NSArray *)pagesFromData:(NSData *)data;
+ (NSArray *)moreThanFive:(NSData *)data;
+ (NSArray *)threePageFetch:(NSString *)next stopFetch:(BOOL)stop;

@end
