//
//  MainViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MainViewController.h"
#import "PopUpViewController.h"
#import "MagicWorldViewController.h"
#import "BookViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ContentBookViewController.h"
#import "AppDelegate.h"
@interface MainViewController () <PopUpDelegate,MagicWorldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *characters;
@property (weak, nonatomic) IBOutlet UIButton *foamCasttleButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *onCakeView;
@property (weak, nonatomic) IBOutlet UIButton *pageTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (strong, nonatomic) PopUpViewController *popUpViewController;
@property (strong, nonatomic) MagicWorldViewController *magicViewController;
@end

@implementation MainViewController

#pragma mark -
#pragma mark - ViewCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLanguage];
    _backgroundImage.image = [UIImage imageNamed:IS_PHONE5? @"MainViewControllerBackground5.png":@"MainViewControllerBackground.png"];
    _onCakeView.frame = CGRectMake(41, 0, _onCakeView.frame.size.width, _onCakeView.frame.size.height);
    if (IS_PHONE5) {
        _onCakeView.frame = CGRectMake(88, 0, _onCakeView.frame.size.width, _onCakeView.frame.size.height);
        
    } else{
        _foamCasttleButton.frame = CGRectMake(_foamCasttleButton.frame.origin.x+30, _foamCasttleButton.frame.origin.y, _foamCasttleButton.frame.size.width, _foamCasttleButton.frame.size.height);
    }
}



#pragma mark -
#pragma mark - MagicWorld Delegate

- (void)close {
    [_magicViewController.view removeFromSuperview];
    _magicViewController = nil;
    [_popUpViewController.view removeFromSuperview];
    _popUpViewController = nil;
}


- (void)next:(int)pageToShow isPrev:(BOOL)prev {
    [self close];
    if (pageToShow == 29) {
        _magicViewController = [[MagicWorldViewController alloc] initWitFromRightAnimation:prev delegate:self];
        [self.view addSubview:_magicViewController.view];
    } else {
        _popUpViewController = [[PopUpViewController alloc] initWithPageNumber:pageToShow fromRightAnimation:prev delegate:self];
        [self.view addSubview:_popUpViewController.view];
    }
}


- (void)openBook {
    [self close];
    [self goToBook:Nil];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)goToBook:(id)sender {
//    ContentBookViewController *bookViewController = [[ContentBookViewController alloc] initWithPageNumber:1];
    BookViewController *bookViewController = [[BookViewController alloc] init];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] audioPlayer] pause];

    [self presentViewController:bookViewController animated:YES completion:NULL];
    //TODO: Go to book. if bookmark is saved, go to bookmark page, also go to first page
}


- (IBAction)goToAppleStoreGift:(id)sender {
    //TODO: Need Apple Store Gift Link
}


- (IBAction)goToNews:(id)sender {
    //TODO: Need news link. also make this with parents gates
}


- (IBAction)goToWriteReview:(id)sender {
    //TODO: Need Apple Store Review Link
}


- (IBAction)changeLanguage:(id)sender {
    if (kRussian) {
        kSetEnglish;
    } else {
        kSetRussian;
    }
    [self updateLanguage];
}


- (IBAction)popUpWindows:(id)sender {
    [self next:[sender tag] isPrev:NO];
}

#pragma mark -
#pragma mark - Private Methods


- (void)updateLanguage {
    [_characters setImage:[Utils imageWithName:@"characters"]];
    [_languageButton setImage:[Utils imageWithName:@"6_language"] forState:UIControlStateNormal];
    [_pageTitleButton setImage:[Utils imageWithName:@"01_banner"] forState:UIControlStateNormal];
}



@end
