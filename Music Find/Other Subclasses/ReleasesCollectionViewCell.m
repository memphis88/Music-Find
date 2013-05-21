//
//  ReleasesCollectionViewCell.m
//  Music Find
//
//  Created by Memphis on 12/9/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import "ReleasesCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReleasesCollectionViewCell


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        self.selectedBackgroundView = bgView;
    }
    return self;
}

@end
