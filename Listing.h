//
//  Listing.h
//  Music Find
//
//  Created by Memphis on 12/12/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Listing : NSObject

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *sleeveCondition;
@property (nonatomic, strong) NSString *ships;
@property (nonatomic, strong) NSURL *resourceURL;
@property (nonatomic, strong) NSURL *URI;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSString *seller;
@property (nonatomic, strong) NSString *displayTitle;

-(id)initWithURL:(NSURL *)url;
-(void)makeListing;
-(void)returnAllStats;

@end
