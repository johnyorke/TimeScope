//
//  CarouselDataSource.h
//  TimeScope
//
//  Created by John Yorke on 27/09/2014.
//  Copyright (c) 2014 Josh Worth / John Yorke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iCarousel/iCarousel.h>

@interface CarouselDataSource : NSObject <iCarouselDataSource>

@property (nonatomic, copy) NSArray *dataArray;

- (id)initWithViewController:(UIViewController *)vc andCarousel:(iCarousel *)carousel;

@end
