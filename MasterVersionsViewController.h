//
//  MasterVersionsViewController.h
//  Music Find
//
//  Created by Memphis on 12/14/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Master;

@interface MasterVersionsViewController : UITableViewController

@property (nonatomic, strong) Master *master;
@property (nonatomic, copy) NSMutableArray *releases;
@property (nonatomic, copy) NSString *displayTitle;

@end
