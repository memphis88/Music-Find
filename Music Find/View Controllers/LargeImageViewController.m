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

/*
 * Κατασκευαστής για τη χρήση αρχείων Nib
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 * Μέθοδος που καλείται κατα τη φόρτωση του ελεγκτή στη μνήμη. Κλήση απαραίτητων μεθόδων για αρχικοποίηση του zoom.
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.frame.size;
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

/*
 * Μέθοδος που επιστρέφει το αντικείμενο που θα γίνεται zoom.
 */

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/*
 * Μέθοδος που καλείται όταν η συσκευή δώσει σήμα ειδοποίησης για γέμισμα της μνήμης.
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Μέθοδος που καλείται όταν αποφορτωθεί ο ελεγκτής απο τη μνήμη.
 */

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
