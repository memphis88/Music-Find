//
//  LargeImageViewController.h
//  Music Find
//
//  Created by Memphis on 12/9/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageViewController : UIViewController

@property (nonatomic, strong) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
