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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [[CarouselDataSource alloc] initWithViewController:self andCarousel:self.carousel];;
    self.carousel.delegate = self;
    self.carousel.dataSource = self.dataSource;
    self.carousel.type = iCarouselTypeTimeMachine;
    [self.carousel setVertical:YES];
    
    self.meterRing.layer.cornerRadius = self.meterRing.frame.size.width / 2;
    self.meterRing.layer.borderColor = [UIColor whiteColor].CGColor;
    self.meterRing.layer.borderWidth = 2;
    
    //self.meterLabel.text = [NSString stringWithFormat:@"%d",self.carousel.currentItemIndex];
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

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if ([self.dataSource.dataArray count] > 0){
    self.meterLabel.text = [self.dataSource.dataArray objectAtIndex:carousel.currentItemIndex];
    }
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
