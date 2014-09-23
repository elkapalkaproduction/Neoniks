//
//  ViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LogoViewController.h"
#import "AudioPlayer.h"
#import "UIImage+Helps.h"
#import "AdsManager.h"

@interface LogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation LogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateImages];
    [self shortAnimation];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[AudioPlayer sharedPlayer] play];
}


- (void)updateImages {

    [_logoImageView setImage:[UIImage imageWithName:@"logo"]];
}


- (void)shortAnimation {
    float timeInterval = 1.f;
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
         _logoImageView.alpha = 1.f;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
             _logoImageView.alpha = 0.f;
         } completion:^(BOOL finished) {
             AdsManager *manager = [AdsManager sharedManager];
             [manager showOnStartAds];
             [self.navigationController popToRootViewControllerAnimated:NO];
         }];
     }];
}

@end
