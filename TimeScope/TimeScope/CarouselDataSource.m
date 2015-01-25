//
//  CarouselDataSource.m
//  TimeScope
//
//  Created by John Yorke on 27/09/2014.
//  Copyright (c) 2014 Josh Worth / John Yorke. All rights reserved.
//

#import "CarouselDataSource.h"

static const NSInteger kDataCount = 1000;

@interface CarouselDataSource ()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, copy) NSArray *colours;

@end

@implementation CarouselDataSource

- (id)initWithViewController:(UIViewController *)vc andCarousel:(iCarousel *)carousel
{
    self = [super init];
    
    if (self) {
        self.viewController = vc;
        self.carousel = carousel;
        [self updateDataArrayUsingNumberOfDays:7 withDate:[NSDate date] fromCurrentCarouselIndex:500];
        self.colours = [self createColourArray];
    }
    
    return self;
}

- (void)updateDataArrayUsingNumberOfDays:(NSInteger)days withDate:(NSDate *)date fromCurrentCarouselIndex:(NSInteger)carouselIndex
{
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:date];
    
    [dateComponents setDay:carouselIndex * days];
    
    NSDate *targetDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    
    for (int x = 0; x < kDataCount; x++) {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:targetDate];
        
        [components setDay:(-x*days)];
        
        NSDate *dateToUse = [cal dateByAddingComponents:components toDate:targetDate options:0];
        
        [mutableArray insertObject:dateToUse atIndex:[mutableArray count]];
    }
    
    self.dataArray = [[NSArray alloc] initWithArray:mutableArray];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.dataArray count];
}

- (UIView *)carousel:( iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //if (view == nil){
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = view.frame.size.width/2;
    UIColor *color = [self.colours objectAtIndex:index];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 2.0f;
    //}
    
    return view;
}

- (NSArray *)createColourArray
{
    NSMutableArray *colors = [NSMutableArray array];
    
    float INCREMENT = 1.0 / kDataCount;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
    
    return [NSArray arrayWithArray:colors];
}

@end
