//
//  MainMenuViewController.m
//  TimeScope
//
//  Created by John Yorke on 09/02/2015.
//  Copyright (c) 2015 Josh Worth / John Yorke. All rights reserved.
//

#import "MenuViewController.h"
#import "UIImageEffects.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.backgroundImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        imageView.image = [UIImageEffects imageByApplyingBlurToImage:self.backgroundImage
                                                          withRadius:30
                                                           tintColor:nil
                                               saturationDeltaFactor:2
                                                           maskImage:nil];
        [self.view insertSubview:imageView atIndex:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)closeButtonTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
