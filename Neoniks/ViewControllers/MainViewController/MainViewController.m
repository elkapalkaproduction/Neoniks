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

@interface MainViewController () <PopUpDelegate, MagicWorldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *characters;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateImagesPosition];
}

#pragma mark -
#pragma mark - MagicWorld Delegate

- (void)close {
    [self.magicViewController.view removeFromSuperview];
    self.magicViewController = nil;
    [self.popUpViewController.view removeFromSuperview];
    self.popUpViewController = nil;
}


- (void)next:(NSInteger)pageToShow isPrev:(BOOL)prev {
    [self close];
    if (pageToShow == 29) {
        self.magicViewController = [[MagicWorldViewController alloc] initWitFromRightAnimation:prev delegate:self];
        [self.view addSubview:self.magicViewController.view];
    } else {
        self.popUpViewController = [[PopUpViewController alloc] initWithPageNumber:pageToShow fromRightAnimation:prev delegate:self];
        [self.view addSubview:self.popUpViewController.view];
    }
}


- (void)openBook {
    [self close];
    [self goToBook:Nil];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)goToBook:(id)sender {
    BookViewController *bookViewController = [[BookViewController alloc] init];
    [[AudioPlayer sharedPlayer] pause];
    
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
    if (isRussian()) {
        setEnglishLanguage();
    } else {
        setRussianLanguage();
    }
    [self updateLanguage];
}


- (IBAction)popUpWindows:(id)sender {
    [self next:[sender tag] isPrev:NO];
}

#pragma mark -
#pragma mark - Private Methods


- (void)updateLanguage {
    [self.characters setImage:[UIImage imageWithName:@"characters"]];
    [self.languageButton setImage:[UIImage imageWithName:@"6_language"]];
    [self.pageTitleButton setImage:[UIImage imageWithName:@"01_banner"]];
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
    } else{
        moveViewHorizontalyWith(30, self.foamCasttleButton);
    }
    changePositon(onCakeOrigin, self.onCakeView);
    
}


@end
