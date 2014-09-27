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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CarouselDataSource *dataSource = [[CarouselDataSource alloc] initWithViewController:self andCarousel:self.carousel];;
    self.carousel.delegate = self;
    self.carousel.dataSource = dataSource;
    self.carousel.type = iCarouselTypeTimeMachine;
    [self.carousel setVertical:YES];
    
    self.meterRing.layer.cornerRadius = self.meterRing.frame.size.width / 2;
    self.meterRing.layer.borderColor = [UIColor whiteColor].CGColor;
    self.meterRing.layer.borderWidth = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
            break;
        case iCarouselOptionTilt:
            return 0;
            break;
        case iCarouselOptionVisibleItems:
            return 8;
        default:
            break;
    }
    
    return value;
}

@end
