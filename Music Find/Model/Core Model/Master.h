//
//  Master.h
//  Music Find
//
//  Created by Memphis on 12/4/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Master : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSURL *resourceURL;
@property (nonatomic, copy) NSMutableArray *tracklist;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSURL *versionsURL;
@property int idNumber;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *displayTitle;

-(id)initWithStats:(NSString *)title resourceURL:(NSURL *)resourceURL idNum:(int)idNumber;
-(void)returnAllStats;
-(void)makeVersionsURL;

@end
