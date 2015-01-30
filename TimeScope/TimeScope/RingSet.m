//
//  RingSet.m
//  TimeScope
//
//  Created by John Yorke on 30/01/2015.
//  Copyright (c) 2015 Josh Worth / John Yorke. All rights reserved.
//

#import "RingSet.h"

static NSString *kFileNamePrefix = @"B3x_";
static const NSInteger kArbitaryUpperRingLimit = 50;

@implementation RingSet

-(id)init
{
    self = [super init];
    
    if (self) {
        self.images = [self createImagesArray];
    }
    
    return self;
}

- (NSArray *)createImagesArray
{    
    NSMutableArray *images = [NSMutableArray new];

    for (int x = 0; x < 50; x++) {
        NSString *string = [NSString stringWithFormat:@"%@%02d",kFileNamePrefix,x];
        UIImage *image = [UIImage imageNamed:string];
        if (image) {
            [images addObject:image];
        } else {
            break;
        }
    }
    
    return [NSArray arrayWithArray:images];
}

@end
