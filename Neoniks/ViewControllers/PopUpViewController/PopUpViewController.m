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
@property (weak, nonatomic) id<PopUpDelegate> delegate;
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
    }

}


#pragma mark -
#pragma mark - IBActions

- (IBAction)goToGallery:(id)sender {
    self.nextPage = 29;
    [self right:nil];
}


- (IBAction)close:(id)sender {
    [Utils animationForAppear:NO forView:self.contentView];
    [self performSelector:@selector(close) withObject:nil afterDelay:kAnimationHide];
}


- (IBAction)right:(id)sender {
    [self hideAnimationToRight];
    [self performSelector:@selector(righttWithDelay) withObject:nil afterDelay:kAnimationHide];
}


- (IBAction)left:(id)sender {
    [self hideAnimationToLeft];
    [self performSelector:@selector(leftWithDelay) withObject:nil afterDelay:kAnimationHide];
}


- (IBAction)yesButton:(id)sender {
    [self hideAnimationToRight];
    [self performSelector:@selector(yesWithDelay) withObject:nil afterDelay:kAnimationHide];
}


#pragma mark -
#pragma mark - Private Methods

- (void)close {
    [self.delegate close];
}


- (void)yesWithDelay {
    [self.delegate openBook];
}


- (void)leftWithDelay {
    [self.delegate next:self.prevPage isPrev:YES];
}


- (void)righttWithDelay {
    [self.delegate next:self.nextPage isPrev:NO];
}


- (void)hideAnimationToRight {
    [Utils animationForAppear:NO fromRight:YES forView:self.contentView];
}


- (void)hideAnimationToLeft {
    [Utils animationForAppear:NO fromRight:NO forView:self.contentView];
}


- (BOOL)isContributorsPage {
    return self.curentPage == 24;
}


- (void)setupView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize screenSize = CGSizeMake(CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
    changeSize(screenSize, self.view);

    [self setupNextPages];
    [self setupImages];
    self.leftButton.hidden = self.prevPage == 0;
    self.rightButton.hidden = self.nextPage == 0;
}


- (void)setupNextPages {
    NSURL *urlForText = [NSURL urlFromLocalizedName:@"nextPages" extension:@"plist"];
    NSDictionary *allPages = [[NSDictionary alloc] initWithContentsOfURL:urlForText];
    NSString *nextPagesKey = [NSString stringWithFormat:@"%d", self.curentPage];
    NSDictionary *curentPage = allPages[nextPagesKey];
    self.nextPage = [curentPage[@"nextPage"] intValue];
    self.prevPage = [curentPage[@"previousPage"] intValue];
    self.galleryButton.hidden = YES;//![curentPage[@"isCharacter"] boolValue];


}


- (void)setupImages {
    NSString *popupImageName = [NSString stringWithFormat:@"%d_popup_art", self.curentPage];
    self.popUpArtImage.image = [UIImage imageWithLocalizedName:popupImageName];
    
    [self.galleryButton setImage:[UIImage imageWithName:@"gallery"]];
    NSString *popupTitleName = [NSString stringWithFormat:@"%d_title", self.curentPage];
    self.popUpTitle.image = [UIImage imageWithName:popupTitleName];
    
    NSString *popupTextImage = [NSString stringWithFormat:@"%d_text", self.curentPage];
    self.textImage.image = [UIImage imageWithName:popupTextImage];

    
}


- (void)startAnimation {
    if (self.isInitialView) {
        [Utils animationForAppear:YES forView:self.contentView];
    } else {
        [self.view setHidden:NO];
        [Utils animationForAppear:YES fromRight:self.fromRightToLeft forView:self.contentView];
    }
}


- (void)adjustControllerForContributorsPage {
    self.popUpBackground.image = [UIImage contributorsBackgroundImage];
    CGFloat crossX = CGRectGetWidth(self.view.frame) - 10 - CGRectGetWidth(self.crossButton.frame);
    changePositon(CGPointMake(crossX, 10), self.crossButton);

    if (!isIphone()) return;
    
    CGFloat popUpTitleX = CGRectGetWidth(self.view.frame) / 2 - CGRectGetWidth(self.popUpTitle.frame) / 2;
    changePositon(CGPointMake(popUpTitleX, 37), self.popUpTitle);
    self.textImage.center = self.view.center;

}

@end
