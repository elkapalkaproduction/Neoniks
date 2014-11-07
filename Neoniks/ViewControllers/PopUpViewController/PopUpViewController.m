//
//  PopUpViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PopUpViewController.h"
#import "UIButton+Helps.h"
#import "Utils.h"

@interface PopUpViewController ()

@property (strong, nonatomic) IBOutlet UIButton *galleryButton;
@property (strong, nonatomic) IBOutlet UIButton *crossButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *popUpBackground;
@property (weak, nonatomic) IBOutlet UIImageView *popUpTitle;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;
@property (weak, nonatomic) IBOutlet UIImageView *popUpArtImage;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) id <PopUpDelegate> delegate;
@property (assign, nonatomic) BOOL fromRightToLeft;
@property (assign, nonatomic) NSInteger curentPage;
@property (assign, nonatomic) BOOL isInitialView;
@property (assign, nonatomic) NSInteger nextPage;
@property (assign, nonatomic) NSInteger prevPage;

@end

@implementation PopUpViewController

#pragma mark -
#pragma mark - LifeCycle

- (id)initWithPageNumber:(PopUpParameters *)param delegate:(id)aDeletegate {
    if (isIphone5()) {
        self = [super initWithNibName:@"PopUpViewController5" bundle:nil];
    } else {
        self = [super init];
    }
    if (self) {
        _curentPage = param.curentPage;
        _fromRightToLeft = param.fromRightToLeft;
        _isInitialView = param.isInitialView;
        _delegate = aDeletegate;
    }

    return self;
}


#pragma mark -
#pragma mark - ViewCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isInitialView) {
        self.contentView.alpha = 0;
    } else {
        self.view.hidden = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnimation];
    if ([self isContributorsPage]) {
        [self adjustControllerForContributorsPage];
    } else if ([self isWillPowerPage]) {
        [self adjustControllerForWillPowerPage];
    }
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)goToGallery:(id)sender {
    self.nextPage = 29;
    [self right:nil];
}


- (IBAction)close:(id)sender {
    NSURL *urlForText = [NSURL urlFromLocalizedName:@"nextPages" extension:@"plist"];
    NSDictionary *allPages = [[NSDictionary alloc] initWithContentsOfURL:urlForText];
    NSString *nextPagesKey = [NSString stringWithFormat:@"%ld", (long)self.curentPage];
    NSDictionary *curentPage = allPages[nextPagesKey];
    if ([curentPage[@"isCharacter"] boolValue]) {
        [self goToGallery:nil];

        return;
    }
    __weak PopUpViewController *weakSelf = self;
    [Utils animationForAppear:NO forView:self.contentView withCompletionBlock:^(BOOL finished) {
         weakSelf.view.hidden = YES;
         [weakSelf.delegate close];
     }];
}


- (IBAction)right:(id)sender {
    __weak PopUpViewController *weakSelf = self;
    [Utils animationForAppear:NO fromRight:YES forView:self.contentView withCompletionBlock:^{
         weakSelf.view.hidden = YES;

         [weakSelf.delegate next:self.nextPage isPrev:NO];
     }];
}


- (IBAction)left:(id)sender {
    __weak PopUpViewController *weakSelf = self;
    [Utils animationForAppear:NO fromRight:NO forView:self.contentView withCompletionBlock:^{
         weakSelf.view.hidden = YES;

         [weakSelf.delegate next:self.prevPage isPrev:YES];
     }];
}


#pragma mark -
#pragma mark - Private Methods

- (BOOL)isContributorsPage {
    return self.curentPage == 24;
}


- (BOOL)isWillPowerPage {
    return self.curentPage == 11;
}


- (void)setupView {
    changeSize([Utils screenSize], self.view);

    [self setupNextPages];
    [self setupImages];
    self.leftButton.hidden = self.prevPage == 0;
    self.rightButton.hidden = self.nextPage == 0;
}


- (void)setupNextPages {
    NSURL *urlForText = [NSURL urlFromLocalizedName:@"nextPages" extension:@"plist"];
    NSDictionary *allPages = [[NSDictionary alloc] initWithContentsOfURL:urlForText];
    NSString *nextPagesKey = [NSString stringWithFormat:@"%ld", (long)self.curentPage];
    NSDictionary *curentPage = allPages[nextPagesKey];
    self.nextPage = [curentPage[@"nextPage"] intValue];
    self.prevPage = [curentPage[@"previousPage"] intValue];
    self.galleryButton.hidden = YES; //![curentPage[@"isCharacter"] boolValue];
}


- (void)setupImages {
    NSString *popupImageName = [NSString stringWithFormat:@"%ld_popup_art", (long)self.curentPage];
    self.popUpArtImage.image = [UIImage imageWithLocalizedName:popupImageName];

    [self.galleryButton setImage:[UIImage imageWithName:@"gallery"]];
    NSString *popupTitleName = [NSString stringWithFormat:@"%ld_title", (long)self.curentPage];
    self.popUpTitle.image = [UIImage imageWithName:popupTitleName];

    NSString *popupTextImage = [NSString stringWithFormat:@"%ld_text", (long)self.curentPage];
    self.textImage.image = [UIImage imageWithName:popupTextImage];
}


- (void)startAnimation {
    if (self.isInitialView) {
        [Utils animationForAppear:YES forView:self.contentView withCompletionBlock:^(BOOL finished) {
         }];
    } else {
        [self.view setHidden:NO];
        [Utils animationForAppear:YES fromRight:self.fromRightToLeft forView:self.contentView withCompletionBlock:^{
         }];
    }
}


- (void)adjustControllerForWillPowerPage {
    self.textImage.frame = self.popUpArtImage.frame;
}


- (void)adjustControllerForContributorsPage {
    self.popUpBackground.image = [UIImage contributorsBackgroundImage];
    NSInteger distanceFromBorders = 10;
    CGFloat crossX = CGRectGetWidth(self.view.frame) - distanceFromBorders - CGRectGetWidth(self.crossButton.frame);
    changePositon(CGPointMake(crossX, distanceFromBorders), self.crossButton);

    if (!isIphone()) return;

    CGFloat popUpTitleX = CGRectGetWidth(self.view.frame) / 2 - CGRectGetWidth(self.popUpTitle.frame) / 2;
    changePositon(CGPointMake(popUpTitleX, 37), self.popUpTitle);
    self.textImage.center = self.view.center;
}

@end
