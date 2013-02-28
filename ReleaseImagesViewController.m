//
//  ReleaseImagesViewController.m
//  Music Find
//
//  Created by Memphis on 12/9/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "ReleaseImagesViewController.h"
#import "ReleasesCollectionViewCell.h"
#import "LargeImageViewController.h"

@interface ReleaseImagesViewController ()

@end

@implementation ReleaseImagesViewController

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
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReleasesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(concurrentQueue, ^{
        if (cell.image.image==nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.spinner startAnimating];
            });
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.images objectAtIndex:indexPath.row] valueForKey:@"uri150"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = [UIImage imageWithData:data];
                [cell.spinner stopAnimating];
            });
        }
        
    });
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSURL *url = [NSURL URLWithString:[[self.images objectAtIndex:indexPath.row] valueForKey:@"uri"]];
    //NSLog(@"row: %d, url:%@", indexPath.row, url);
    [self performSegueWithIdentifier:@"LargeImage" sender:url];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LargeImage"])
    {
        LargeImageViewController *lIVC = [segue destinationViewController];
        lIVC.imageURL = sender;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
