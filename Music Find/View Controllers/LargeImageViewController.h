//
//  LargeImageViewController.h
//  Music Find
//
//  Created by Memphis on 12/9/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
