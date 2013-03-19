//
//  DescriptionViewController.h
//  Music Find
//
//  Created by Memphis on 11/28/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Artist;

@interface DescriptionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (strong, nonatomic) Artist *artist;

-(void)loadDescription;

@end
