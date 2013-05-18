//
//  Artist.h
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSArray *links;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSURL *resourceURL;
@property (nonatomic, copy) NSURL *releasesURL;
@property (nonatomic, copy) NSString *profile;
@property int idNumber;

-(id)initWithStats:(NSString *)title resourceURL:(NSURL *)resourceURL idNum:(int)idNumber;
-(void)returnAllStats;
@end
