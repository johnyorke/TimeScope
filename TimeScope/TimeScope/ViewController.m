//
//  ViewController.m
//  TimeScope
//
//  Created by John Yorke on 27/09/2014.
//  Copyright (c) 2014 Josh Worth / John Yorke. All rights reserved.
//

#import "ViewController.h"
#import "RingSet.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *meterRing;
@property (weak, nonatomic) IBOutlet UIView *meterRingHandle;
@property (weak, nonatomic) IBOutlet UILabel *meterLabel;
@property (nonatomic, strong) UIImageView *ringView;
@property (nonatomic, strong) UIImageView *gradientView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.tintColor = [UIColor colorWithRed:0.00 green:0.73 blue:1.00 alpha:1.0];
    
    self.meterRing.layer.cornerRadius = self.meterRing.frame.size.width / 2;
    self.meterRing.layer.borderColor = [UIColor whiteColor].CGColor;
    self.meterRing.layer.borderWidth = 2;
    
    self.currentIndex = 0;
    
    RingSet *ringSet = [RingSet new];
    
    self.images = ringSet.images;
    
    self.ringView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.ringView.image = [self.images objectAtIndex:self.currentIndex];
    self.ringView.userInteractionEnabled = YES;
    [self.view insertSubview:self.ringView belowSubview:self.meterRing];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ringViewDidPan:)];
    [self.ringView addGestureRecognizer:pan];
    
    self.currentDate = [NSDate date];
    
    self.meterLabel.attributedText = [self attributedStringFromDate:self.currentDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)ringViewDidPan:(UIPanGestureRecognizer *)pan
{    
    CGPoint velocity = [pan velocityInView:self.ringView];
    
    [self scrollRingUsingVelocty:velocity];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint newVelocity = velocity;
        if (newVelocity.y < 0) {
            newVelocity = CGPointMake(0, 0 - newVelocity.y);
        }
        for (int x = 0; x < newVelocity.y / 55; x++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(x * 0.015 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrollRingUsingVelocty:velocity];
            });;
        }
    }
    
}

- (void)scrollRingUsingVelocty:(CGPoint)velocity
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    if (velocity.y < 0) {
        self.currentIndex = self.currentIndex + 1;
        dateComponents.day = 7;
    } else {
        self.currentIndex = self.currentIndex - 1; 
        dateComponents.day = -7;
    }
    
    if (self.currentIndex == [self.images count]) {
        self.currentIndex = 0;
    } else if (self.currentIndex < 0) {
        self.currentIndex = [self.images count] - 1;
    }
    
    self.meterLabel.attributedText = [self attributedStringFromDate:[self dateByAddingComponent:dateComponents]];
    
    [self updateRingViewWithUsingImage:[self.images objectAtIndex:self.currentIndex]];
}

- (void)updateRingViewWithUsingImage:(UIImage *)image
{
    if (!self.gradientView) {
        self.gradientView = [[UIImageView alloc] initWithFrame:self.ringView.frame];
        [self.view addSubview:self.gradientView];
    }
    
    self.ringView.image = image;
    
}

- (UIImage*)imageWithColorOverlay:(UIColor*)colorOverlay usingImage:(UIImage *)image
{   
    // create drawing context 
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    // draw current image
    [image drawAtPoint:CGPointZero];
    
    // determine bounding box of current image
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // get drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // flip orientation
    CGContextTranslateCTM(context, 0.0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set overlay
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextClipToMask(context, rect, image.CGImage);
    
    CGFloat colors [] = { 
        0.75, 1.0, 0.25, 1.0, 
        1.0, 0.0, 0.0, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    CGContextDrawRadialGradient(context, gradient, startPoint, 0, endPoint, self.view.frame.size.height, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    // save drawing-buffer
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end drawing context
    UIGraphicsEndImageContext();
    
    return returnImage;
}

- (NSDate *)dateByAddingComponent:(NSDateComponents *)components
{
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.currentDate options:0];
    
    self.currentDate = newDate;
    
    return newDate;
}

- (NSAttributedString *)attributedStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"d MMMM, yyyy";
    NSString *dateString = [[dateFormat stringFromDate:date] uppercaseString];
    
    dateFormat.dateFormat = @"hh:mm a";
    NSString *timeString = [[dateFormat stringFromDate:date] uppercaseString];
    
    NSString *combinedString = [NSString stringWithFormat:@"%@\n%@",dateString,timeString];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:combinedString attributes:nil];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:[combinedString rangeOfString:dateString]];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[combinedString rangeOfString:timeString]];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[combinedString rangeOfString:timeString]];
    
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

@end
