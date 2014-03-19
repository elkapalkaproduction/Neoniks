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
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface MainViewController () <PopUpDelegate,MagicWorldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *characters;
@property (weak, nonatomic) IBOutlet UIButton *foamCasttleButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *onCakeView;
@property (weak, nonatomic) IBOutlet UIButton *pageTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [self updateLanguage];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _backgroundImage.image = [UIImage imageNamed:IS_PHONE5? @"MainViewControllerBackground5.png":@"MainViewControllerBackground.png"];
    _onCakeView.frame = CGRectMake(41, 0, _onCakeView.frame.size.width, _onCakeView.frame.size.height);
    if (IS_PHONE5) {
        _onCakeView.frame = CGRectMake(88, 0, _onCakeView.frame.size.width, _onCakeView.frame.size.height);
        
    } else{
        _foamCasttleButton.frame = CGRectMake(_foamCasttleButton.frame.origin.x+30, _foamCasttleButton.frame.origin.y, _foamCasttleButton.frame.size.width, _foamCasttleButton.frame.size.height);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateLanguage{
    [_characters setImage:[Utils imageWithName:@"characters"]];
    [_languageButton setImage:[Utils imageWithName:@"6_language"] forState:UIControlStateNormal];
    [_pageTitleButton setImage:[Utils imageWithName:@"01_banner"] forState:UIControlStateNormal];
}
#pragma mark - 
#pragma mark - IBActions
- (IBAction)goToBook:(id)sender {
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

    //TODO: Changes Language
}
#pragma mark - 
#pragma mark - On Cake Action
- (IBAction)popUpWindows:(id)sender {
    if ([sender tag] == 29) {
        [[MagicWorldViewController sharedManager] setDelegate:self];
        [[[MagicWorldViewController sharedManager]view] setHidden:YES];
        [[MagicWorldViewController sharedManager] setFromRightToLeft:NO];
        [self.view addSubview:[[MagicWorldViewController sharedManager]view]];
    }else{
        [[PopUpViewController sharedManager] setDelegate:self];
        [[PopUpViewController sharedManager] setFromRightToLeft:NO];
        [[PopUpViewController sharedManager] setCurentPage:(int)[sender tag]];
        [[[PopUpViewController sharedManager]view] setHidden:YES];
        [self.view addSubview:[[PopUpViewController sharedManager]view]];
    }
}
#pragma mark -
#pragma mark - MagicWorld Delegate
-(void)closeWorld{
    [[[MagicWorldViewController sharedManager] view] removeFromSuperview];
}
-(void)show:(int)pageToShow{
    [[[MagicWorldViewController sharedManager] view] removeFromSuperview];
    [[PopUpViewController sharedManager] setDelegate:self];
    [[PopUpViewController sharedManager] setFromRightToLeft:NO];
    [[PopUpViewController sharedManager] setCurentPage:pageToShow];
    [[[PopUpViewController sharedManager]view] setHidden:YES];
    [self.view addSubview:[[PopUpViewController sharedManager]view]];

}
#pragma mark -
#pragma mark - PopUp Delegate
-(void)close{
    [[[PopUpViewController sharedManager] view] removeFromSuperview];
}
-(void)next:(int)pageToShow isPrev:(BOOL)prev{
    [[[MagicWorldViewController sharedManager] view] removeFromSuperview];
    [[[PopUpViewController sharedManager] view] removeFromSuperview];
    if (pageToShow == 29) {
        [[MagicWorldViewController sharedManager] setDelegate:self];
        [[[MagicWorldViewController sharedManager]view] setHidden:YES];
        [[MagicWorldViewController sharedManager] setFromRightToLeft:prev];
        [self.view addSubview:[[MagicWorldViewController sharedManager]view]];
    } else {
    [[PopUpViewController sharedManager] setDelegate:self];
    [[PopUpViewController sharedManager] setFromRightToLeft:prev];

    [[PopUpViewController sharedManager] setCurentPage:pageToShow];
    [[[PopUpViewController sharedManager]view] setHidden:YES];
    [self.view addSubview:[[PopUpViewController sharedManager]view]];
    }
}
-(void)openBook{
    [[[PopUpViewController sharedManager] view] removeFromSuperview];
    [self goToBook:Nil];
}

@end
