//
//  CarouselDataSource.m
//  TimeScope
//
//  Created by John Yorke on 27/09/2014.
//  Copyright (c) 2014 Josh Worth / John Yorke. All rights reserved.
//

#import "CarouselDataSource.h"

@interface CarouselDataSource ()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, copy) NSArray *views;

@end

@implementation CarouselDataSource

- (id)initWithViewController:(UIViewController *)vc andCarousel:(iCarousel *)carousel
{
    self = [super init];
    
    if (self) {
        self.viewController = vc;
        self.carousel = carousel;
    }
    
    return self;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 8;
}

- (UIView *)carousel:( iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil){
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"TimeRing"];
        view.contentMode = UIViewContentModeCenter;
        view.backgroundColor = [UIColor clearColor];
    }
    
    return view;
}


@end
