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
#import "TableOfContentsViewController.h"
#import "Utils.h"
#import "AdsManager.h"
#import "NNKParentAlertView.h"

#ifdef NeoniksFree
NSString *const giftAppId = @"899196882";
NSString *const rateAppId = @"899196882";
#else
NSString *const giftAppId = @"912236449";
NSString *const rateAppId = @"912236449";
#endif
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
@property (strong, nonatomic) NSTimer *idleTimer;

@end

@implementation MainViewController

#pragma mark -
#pragma mark - ViewCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateImagesPosition];
    [self resetIdleTimer];
}


- (void)resetIdleTimer {
    if (!self.idleTimer) {
        self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                                                          target:self
                                                        selector:@selector(idleTimerExceeded)
                                                        userInfo:nil
                                                         repeats:NO];
    } else {
        if (fabs([self.idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds - 1.0) {
            [self.idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}


- (void)idleTimerExceeded {
    self.idleTimer = nil;
    AdsManager *manager = [AdsManager sharedManager];
    [manager showOnTimerAds];
    [self resetIdleTimer];
}


- (UIResponder *)nextResponder {
    [self resetIdleTimer];

    return [super nextResponder];
}


#pragma mark -
#pragma mark - MagicWorld Delegate

- (void)closeWithShadow:(BOOL)withShadow {
    if (withShadow) {
        [self closeAndHideShadow];
    } else {
        [self closeWithoutHidingShadow];
    }
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
        if (pageToShow != 24) {
            [self.view bringSubviewToFront:self.readBookView];
        }
        if (pageToShow == 24) {
            [AdsManager logEvent:FLURRY_CONTRIBUTORS];
            [self.view bringSubviewToFront:self.shadowView];
            [self.view bringSubviewToFront:self.site];
            [self.view bringSubviewToFront:self.popUpViewController.view];
        }
    }
}


- (void)next:(NSInteger)pageToShow isPrev:(BOOL)prev {
    [AdsManager logEvent:FLURRY_POPUP_WINDOWS_ARROW];
    [self next:pageToShow isPrev:prev isInitial:NO];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)enableSound:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[AudioPlayer sharedPlayer] pause];
    } else {
        [[AudioPlayer sharedPlayer] play];
    }
}


- (IBAction)goToBook:(id)sender {
    [AdsManager logEvent:FLURRY_BOOK_OPEN];
    BookViewController *bookViewController = [[BookViewController alloc] init];
    bookViewController.isPlayingSound = [[AudioPlayer sharedPlayer] isPlaying];

    [[AudioPlayer sharedPlayer] pause];
    [self presentViewController:bookViewController animated:YES completion:NULL];
}


- (IBAction)goToAppleStoreGift:(id)sender {
#ifdef NeoniksFree
    [AdsManager logEvent:FLURRY_MAKE_GIFT];
    [[UIApplication sharedApplication] openURL:[NSURL rateAppWithID:giftAppId]];
#else
    NNKParentAlertView *alertView = [[NNKParentAlertView alloc] initCustomPopWithFrame:self.view.frame completionBlock:^{
        [AdsManager logEvent:FLURRY_MAKE_GIFT];
        [[UIApplication sharedApplication] openURL:[NSURL rateAppWithID:giftAppId]];
    }];;
    [alertView showInView:self.view];
#endif
}


- (IBAction)goToSite:(id)sender {
#ifdef NeoniksFree
    [[UIApplication sharedApplication] openURL:[NSURL urlForSite]];
#else
    NNKParentAlertView *alertView = [[NNKParentAlertView alloc] initCustomPopWithFrame:self.view.frame completionBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL urlForSite]];
    }];;
    [alertView showInView:self.view];
#endif
}


- (IBAction)goToWriteReview:(id)sender {
#ifdef NeoniksFree
    [AdsManager logEvent:FLURRY_RATE_US];
    [[UIApplication sharedApplication] openURL:[NSURL rateAppWithID:rateAppId]];
#else
    NNKParentAlertView *alertView = [[NNKParentAlertView alloc] initCustomPopWithFrame:self.view.frame completionBlock:^{
        [AdsManager logEvent:FLURRY_RATE_US];
        [[UIApplication sharedApplication] openURL:[NSURL rateAppWithID:rateAppId]];
    }];;
    [alertView showInView:self.view];
#endif

}


- (IBAction)changeLanguage:(id)sender {
    [AdsManager logEvent:FLURRY_LANGUAGE_CHANGED];
    if (isRussian()) {
        setEnglishLanguage();
    } else {
        setRussianLanguage();
    }
    [self updateLanguage];
}


- (IBAction)popUpWindows:(id)sender {
    if (self.magicViewController || self.popUpViewController) {
        return;
    }
    [AdsManager logEvent:FLURRY_MAP];
    [Utils animationForAppear:YES forView:self.shadowView withCompletionBlock:^(BOOL finished) {
     }];
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


- (void)closeAndHideShadow {
    __weak MainViewController *weakSelf = self;
    [Utils animationForAppear:NO forView:self.shadowView withCompletionBlock:^(BOOL finished) {
         [weakSelf.magicViewController.view removeFromSuperview];
         weakSelf.magicViewController = nil;
         [weakSelf.popUpViewController.view removeFromSuperview];
         weakSelf.popUpViewController = nil;
     }];
}


- (void)closeWithoutHidingShadow {
    [self.magicViewController.view removeFromSuperview];
    self.magicViewController = nil;
    [self.popUpViewController.view removeFromSuperview];
    self.popUpViewController = nil;
}


- (void)updateImagesPosition {
    [self updateLanguage];
    CGPoint onCakeOrigin = CGPointMake(41, 0);
    NSString *backgroundImageName = @"MainViewControllerBackground.png";
    if (isIphone5()) {
        backgroundImageName = @"MainViewControllerBackground5.png";
        onCakeOrigin.x = 88;
    }
    self.backgroundImage.image = [UIImage imageNamed:backgroundImageName];
    changePositon(onCakeOrigin, self.onCakeView);
}

@end
