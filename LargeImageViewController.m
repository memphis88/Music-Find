//
//  LargeImageViewController.m
//  Music Find
//
//  Created by Memphis on 12/9/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "LargeImageViewController.h"
#import "SVProgressHUD.h"

@interface LargeImageViewController ()

@end

@implementation LargeImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"%@",self.imageURL);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        });
        NSData *data = [NSData dataWithContentsOfURL:self.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:data];
            [SVProgressHUD dismiss];
        });
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
