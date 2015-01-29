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

@property (weak, nonatomic) IBOutlet UIView *meterRing;
@property (weak, nonatomic) IBOutlet UIView *meterRingHandle;
@property (weak, nonatomic) IBOutlet UILabel *meterLabel;
@property (strong, nonatomic) CarouselDataSource *dataSource;
@property (nonatomic, strong) UIImageView *ringView;
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
    
    NSArray *imageNames = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
    
    NSMutableArray *mutableImages = [NSMutableArray new];
    for (int x = 0; x < [imageNames count]; x++) {
        [mutableImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:x]]];
    }
    self.images = [NSArray arrayWithArray:mutableImages];
    
    self.ringView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.ringView.image = [self.images objectAtIndex:self.currentIndex];
    self.ringView.userInteractionEnabled = YES;
    [self.view addSubview:self.ringView];
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
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    if (velocity.y < 0) {
        self.currentIndex++;
        dateComponents.day = 7;
    } else {
       self.currentIndex--; 
        dateComponents.day = -7;
    }
    
    if (self.currentIndex == [self.images count]) {
        self.currentIndex = 0;
    } else if (self.currentIndex < 0) {
        self.currentIndex = [self.images count] - 1;
    }
    
    self.meterLabel.attributedText = [self attributedStringFromDate:[self dateByAddingComponent:dateComponents]];
    
    self.ringView.image = [self.images objectAtIndex:self.currentIndex];
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
