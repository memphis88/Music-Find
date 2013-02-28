//
//  Release.h
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Release : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) UIImage *primaryImage;
@property (nonatomic, copy) NSURL *resourceURL;
@property (nonatomic, copy) NSMutableArray *tracklist;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *genre;
@property int idNumber;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSMutableArray *listings;
@property (nonatomic, copy) NSMutableArray *listingTitles;
@property (nonatomic, copy) NSString *displayTitle;

-(id)initWithStats:(NSString *)title :(NSURL *)resourceURL :(int)idNumber :(NSString *)format;
-(void)returnAllStats;

@end
