//
//  ViewController.m
//  TimeScope
//
//  Created by John Yorke on 27/09/2014.
//  Copyright (c) 2014 Josh Worth / John Yorke. All rights reserved.
//

#import "ViewController.h"
#import "CarouselDataSource.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIView *meterRing;
@property (weak, nonatomic) IBOutlet UIView *meterRingHandle;
@property (weak, nonatomic) IBOutlet UILabel *meterLabel;
@property (strong, nonatomic) CarouselDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.tintColor = [UIColor colorWithRed:0.84 green:0.15 blue:0.96 alpha:1.0];
    self.dataSource = [[CarouselDataSource alloc] initWithViewController:self andCarousel:self.carousel];;
    self.carousel.delegate = self;
    self.carousel.dataSource = self.dataSource;
    self.carousel.type = iCarouselTypeTimeMachine;
    [self.carousel setVertical:YES];
    
    self.meterRing.layer.cornerRadius = self.meterRing.frame.size.width / 2;
    self.meterRing.layer.borderColor = [UIColor whiteColor].CGColor;
    self.meterRing.layer.borderWidth = 2;
    
    [self setScaleLabelTextWithSliderValue:self.slider.value];
    
    [self.slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventAllEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap:
            return NO;
            break;
        case iCarouselOptionTilt:
            return 0;
            break;
        case iCarouselOptionVisibleItems:
            return 40;
        default:
            break;
    }
    
    return value;
}

- (void)sliderUpdated:(UISlider *)slider
{
    NSInteger sliderValue = slider.value;
    
    NSDate *date = [self.dataSource.dataArray objectAtIndex:self.carousel.currentItemIndex];
    
    [self.dataSource updateDataArrayUsingNumberOfDays:sliderValue withDate:date fromCurrentCarouselIndex:self.carousel.currentItemIndex];
    
    [self.carousel reloadData];
        
    [self setScaleLabelTextWithSliderValue:slider.value];
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if ([self.dataSource.dataArray count] > 0){
        NSDate *date = [self.dataSource.dataArray objectAtIndex:self.carousel.currentItemIndex];
        self.meterLabel.text = [self stringFromDate:date];
    }
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //dateFormat.dateStyle = NSDateFormatterLongStyle;
    dateFormat.dateFormat = @"d MMMM yyyy, G";
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

- (void)setScaleLabelTextWithSliderValue:(CGFloat)value
{
    self.scaleLabel.alpha = 1;
    NSInteger sliderValue = value;

    NSString *labelUnitText= nil;
    
    if (sliderValue <= 7) {
        if (sliderValue == 1) {
            labelUnitText = @"Day";
        } else labelUnitText = @"Days";
        self.scaleLabel.text = [NSString stringWithFormat:@"%ld %@",(long)sliderValue,labelUnitText];
    } else if (sliderValue > 7 && sliderValue <= 30) {
        NSInteger weeks = sliderValue / 7;
        if (weeks == 1) {
            labelUnitText = @"Week";
        } else labelUnitText = @"Weeks";
        self.scaleLabel.text = [NSString stringWithFormat:@"%ld %@",(long)weeks,labelUnitText];
    } else if (sliderValue > 30 && sliderValue <= 365) {
        NSInteger months = sliderValue / 30;
        if (months == 1) {
            labelUnitText = @"Month";
        } else labelUnitText = @"Months";
        self.scaleLabel.text = [NSString stringWithFormat:@"%ld %@",(long)months,labelUnitText];
    } else if (sliderValue > 365) {
        NSInteger years = sliderValue / 365;
        if (years == 1) {
            labelUnitText = @"Year";
        } else labelUnitText = @"Years";
        self.scaleLabel.text = [NSString stringWithFormat:@"%ld %@",(long)years,labelUnitText];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            self.scaleLabel.alpha = 0;
        }];
    });
}

//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
//{
//    CGFloat tilt = 0;
//    CGFloat spacing = 1;
//    
//    NSLog(@"offset = %f", offset);
//
//    return CATransform3DTranslate(transform, 0.0, offset * carousel.currentItemView.frame.size.width * tilt, offset * carousel.currentItemView.frame.size.width * spacing);
//}

@end
