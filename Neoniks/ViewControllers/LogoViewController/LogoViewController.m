//
//  ViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LogoViewController.h"
#import "MainViewController.h"
#import "AudioPlayer.h"

@interface LogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *islandImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *onCake;
@property (weak, nonatomic) IBOutlet UIImageView *waterfallImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foamCasttleButton;

@property (weak, nonatomic) IBOutlet UIImageView *pageTitleButton;
@property (weak, nonatomic) IBOutlet UIImageView *languageButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide1;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide2;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide3;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide4;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide5;
@property (weak, nonatomic) IBOutlet UIView *onCakeView;

@end

@implementation LogoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self updateImages];
    [self longAnimation];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)updateImages {
    NSString *backgroundImageName = @"MainViewControllerBackground.png";
    if (isIphone5()) {
        backgroundImageName = @"MainViewControllerBackground5.png";
    }
    _islandImageView.image = [UIImage imageNamed:backgroundImageName];
    [_logoImageView setImage:[UIImage imageWithName:@"logo"]];
    [_languageButton setImage:[UIImage imageWithName:@"6_language"]];
    [_pageTitleButton setImage:[UIImage imageWithName:@"01_banner"]];
    CGPoint onCakeOrigin = CGPointMake(41, 0);
    if (isIphone5()) {
        onCakeOrigin.x = 88;
    } else{
        moveViewHorizontalyWith(30, self.foamCasttleButton);
    }
    changePositon(onCakeOrigin, self.onCakeView);
    
}


- (void)shortAnimation {
    float timeInterval = 1.f;
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logoImageView.alpha = 1.f;
    } completion:^(BOOL finished) {
        MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [[self navigationController] pushViewController:viewController animated:NO];
    }];
    
}


- (void)longAnimation {
    float timeInterval = 1.f;
    
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logoImageView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
            _logoImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [[AudioPlayer sharedPlayer] play];
            [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
                _islandImageView.alpha = 1.f;
                _waterfallImageView.alpha = 1.f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:timeInterval*0.75f animations:^{
                    for (UIImageView *img in _onCake) {
                        if (img.tag == 1) img.alpha = 1.f;
                    }
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:timeInterval*0.75f animations:^{
                        for (UIImageView *img in _onCake) {
                            if (img.tag == 2) img.alpha = 1.f;
                        }
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:timeInterval*0.75f animations:^{
                            for (UIImageView *img in _onCake) {
                                if (img.tag == 3) img.alpha = 1.f;
                            }
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:timeInterval/5 animations:^{
                                _leftSide1.alpha = 1.f;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:timeInterval/5 animations:^{
                                    _leftSide2.alpha = 1.f;
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:timeInterval/5 animations:^{
                                        _leftSide3.alpha = 1.f;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:timeInterval/5 animations:^{
                                            _leftSide4.alpha = 1.f;
                                        } completion:^(BOOL finished) {
                                            [UIView animateWithDuration:timeInterval/5 animations:^{
                                                _leftSide5.alpha = 1.f;
                                            } completion:^(BOOL finished) {
                                                [UIView animateWithDuration:timeInterval/2 animations:^{
                                                    _languageButton.alpha = 1.f;
                                                } completion:^(BOOL finished) {
                                                    [UIView animateWithDuration:timeInterval/2 animations:^{
                                                        _pageTitleButton.alpha = 1.f;
                                                    } completion:^(BOOL finished) {
                                                        MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                                                        [[self navigationController] pushViewController:viewController animated:NO];
                                                    }];
                                                    
                                                }];
                                                
                                            }];
                                            
                                        }];
                                        
                                    }];
                                    
                                }];
                                
                            }];
                        }];
                    }];
                    
                }];
                
            }];
        }];
    }];
    
}

@end
