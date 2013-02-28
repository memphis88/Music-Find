//
//  DataController.h
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DataController : NSObject
@property (nonatomic, copy) NSMutableArray *artists;
@property (nonatomic, copy) NSMutableArray *releases;
@property (nonatomic, copy) NSMutableArray *masters;

- (void)artistAndReleaseFromJson:(NSArray *)array;
+ (NSMutableArray *)mastersFromJson:(NSArray *)array;
+ (NSMutableArray *)releasesFromJson:(NSArray *)array;
+ (NSString *)primaryImage150FromJson:(NSArray *)array;
+ (NSMutableArray *)versionsFromJson:(NSArray *)array;
+ (NSMutableArray *)returnTrackList:(NSDictionary *)dic;
- (int)sectionCount;

@end
