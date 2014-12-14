//
//  CarouselDataSource.m
//  TimeScope
//
//  Created by John Yorke on 27/09/2014.
//  Copyright (c) 2014 Josh Worth / John Yorke. All rights reserved.
//

#import "CarouselDataSource.h"

static const NSInteger kDataCount = 100;

@interface CarouselDataSource ()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) iCarousel *carousel;

@end

@implementation CarouselDataSource

- (id)initWithViewController:(UIViewController *)vc andCarousel:(iCarousel *)carousel
{
    self = [super init];
    
    if (self) {
        self.viewController = vc;
        self.carousel = carousel;
        [self createDataArray];
    }
    
    return self;
}

- (void)createDataArray
{
    NSMutableArray *mutableArray = [NSMutableArray new];
            
    for (int x = 0; x < kDataCount; x++) {
        NSDate *date = [NSDate date];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:date];
        
        [components setDay:-x];
        
        NSDate *dateToUse = [cal dateByAddingComponents:components toDate:date options:0];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateStyle = NSDateFormatterLongStyle;
        NSString *dateString = [dateFormat stringFromDate:dateToUse];
        [mutableArray addObject:dateString];
    }
    
    self.dataArray = [[NSArray alloc] initWithArray:mutableArray];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.dataArray count];
}

- (UIView *)carousel:( iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = view.frame.size.width/2;
        view.layer.borderColor = [UIColor colorWithRed:0.84 green:0.15 blue:0.96 alpha:1.0].CGColor;
        view.layer.borderWidth = 1.0f;
    }
    
    return view;
}


@end
