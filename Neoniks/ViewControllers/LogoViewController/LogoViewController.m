//
//  ViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LogoViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
@interface LogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *islandImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *onCake;
@property (weak, nonatomic) IBOutlet UIImageView *waterfallImageView;

@property (weak, nonatomic) IBOutlet UIImageView *pageTitleButton;
@property (weak, nonatomic) IBOutlet UIImageView *languageButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide1;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide2;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide3;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide4;
@property (weak, nonatomic) IBOutlet UIImageView *leftSide5;

@end

@implementation LogoViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_logoImageView setImage:[Utils imageWithName:@"logo"]];
    [_languageButton setImage:[Utils imageWithName:@"6_language"]];
    [_pageTitleButton setImage:[Utils imageWithName:@"01_banner"]];
}
- (void)viewDidLoad
{
    float timeInterval = 1.f;
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logoImageView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
            _logoImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [[(AppDelegate *)[[UIApplication sharedApplication] delegate] audioPlayer] play];
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
                                                                [[self navigationController] pushViewController:viewController animated:NO];                                                            }];

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

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
