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
#import "ContentOfBookViewController.h"
#import "Utils.h"

@interface MainViewController () <PopUpDelegate, MagicWorldDelegate>

@property (weak, nonatomic) IBOutlet UIView *readBookView;
@property (weak, nonatomic) IBOutlet UIImageView *characters;
@property (weak, nonatomic) IBOutlet UIButton *foamCasttleButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *onCakeView;
@property (weak, nonatomic) IBOutlet UIButton *pageTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

@property (strong, nonatomic) PopUpViewController *popUpViewController;
@property (strong, nonatomic) MagicWorldViewController *magicViewController;

@property (strong, nonatomic) IBOutlet UIImageView *header;
@property (strong, nonatomic) IBOutlet UIButton *naruke;
@property (strong, nonatomic) IBOutlet UIButton *site;
@property (strong, nonatomic) IBOutlet UIButton *contributors;
@property (strong, nonatomic) IBOutlet UIButton *gift;
@property (strong, nonatomic) IBOutlet UIButton *rateUs;
@property (strong, nonatomic) IBOutlet UIImageView *readTheBook;

@end

@implementation MainViewController

#pragma mark -
#pragma mark - ViewCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateImagesPosition];
}


#pragma mark -
#pragma mark - MagicWorld Delegate

- (void)closeWithShadow:(BOOL)withShadow {
    if (withShadow) {
        [Utils animationForAppear:NO forView:self.shadowView];
    }
    [self.magicViewController.view removeFromSuperview];
    self.magicViewController = nil;
    [self.popUpViewController.view removeFromSuperview];
    self.popUpViewController = nil;
}


- (void)close {
    [self closeWithShadow:YES];
}


- (void)next:(NSInteger)pageToShow isPrev:(BOOL)prev isInitial:(BOOL)isIntial {
    [self closeWithShadow:NO];
    if (pageToShow == 29) {
        self.magicViewController = [[MagicWorldViewController alloc] initWitFromRightAnimation:prev isInitialView:isIntial delegate:self];
        [self.view bringSubviewToFront:self.shadowView];
        [self.view addSubview:self.magicViewController.view];
    } else {
        PopUpParameters *param = [[PopUpParameters alloc] init];
        param.isInitialView = isIntial;
        param.curentPage = pageToShow;
        param.fromRightToLeft = prev;
        self.popUpViewController = [[PopUpViewController alloc] initWithPageNumber:param delegate:self];
        [self.view addSubview:self.popUpViewController.view];
        [self.view bringSubviewToFront:self.readBookView];
        if (pageToShow == 24) {
            [self.view bringSubviewToFront:self.site];
        }
        
    }
}


- (void)next:(NSInteger)pageToShow isPrev:(BOOL)prev {
    [self next:pageToShow isPrev:prev isInitial:NO];
}


- (void)openBook {
    [self closeWithShadow:YES];
    [self goToBook:Nil];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)goToBook:(id)sender {
    BookViewController *bookViewController = [[BookViewController alloc] init];
    [[AudioPlayer sharedPlayer] pause];
    
    [self presentViewController:bookViewController animated:YES completion:NULL];
}


- (IBAction)goToAppleStoreGift:(id)sender {
    //TODO: Need Apple Store Gift Link
}


- (IBAction)goToSite:(id)sender {
    //TODO: Need news link. also make this with parents gates
}


- (IBAction)goToWriteReview:(id)sender {
    //TODO: Need Apple Store Review Link
}


- (IBAction)changeLanguage:(id)sender {
    if (isRussian()) {
        setEnglishLanguage();
    } else {
        setRussianLanguage();
    }
    [self updateLanguage];
}


- (IBAction)popUpWindows:(id)sender {
    [Utils animationForAppear:YES forView:self.shadowView];
    [self next:[sender tag] isPrev:NO isInitial:YES];
}


#pragma mark -
#pragma mark - Private Methods

- (void)updateLanguage {
    [self.characters setImage:[UIImage imageWithName:@"characters"]];
    [self.languageButton setImage:[UIImage imageWithName:@"6_language"]];
    [self.pageTitleButton setImage:[UIImage imageWithName:@"01_banner"]];
    [self.readTheBook setImage:[UIImage imageWithName:@"read_text"]];
    [self.naruke setImage:[UIImage imageWithName:@"07_naruke"]];
    [self.rateUs setImage:[UIImage imageWithName:@"rate"]];
    [self.gift setImage:[UIImage imageWithName:@"gift"]];
    [self.site setImage:[UIImage imageWithName:@"www"]];
    [self.contributors setImage:[UIImage imageWithName:@"contributions"]];
    [self.header setImage:[UIImage imageWithName:@"headings"]];
}


- (void)updateImagesPosition {
    [self updateLanguage];
    NSString *backgroundImageName = @"MainViewControllerBackground.png";
    if (isIphone5()) {
        backgroundImageName = @"MainViewControllerBackground5.png";
    }
    self.backgroundImage.image = [UIImage imageNamed:backgroundImageName];
    CGPoint onCakeOrigin = CGPointMake(41, 0);
    if (isIphone5()) {
        onCakeOrigin.x = 88;
    } else {
//        moveViewHorizontalyWith(-30, self.foamCasttleButton);
    }
    changePositon(onCakeOrigin, self.onCakeView);
}

@end
