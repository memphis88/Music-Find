//
//  masterResultTableViewController.h
//  Music Find
//
//  Created by Memphis on 11/11/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController, Artist;

@interface MasterResultTableViewController : UITableViewController

@property (nonatomic, strong) DataController  *dataController;
@property (nonatomic, weak) NSString *query;
@property (weak, nonatomic) IBOutlet UILabel *queryLabel;
@property (weak, nonatomic) NSString *next;

@property BOOL stopFetch;

@end
