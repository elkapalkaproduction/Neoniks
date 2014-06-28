//
//  MagicWorldViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/15/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MagicWorldViewController.h"
#import "Utils.h"
#import "MagicWorldPortrait.h"

@interface MagicWorldViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *popUpTitle;
@property (nonatomic, assign) BOOL fromRightToLeft;
@property (nonatomic, weak) id <MagicWorldDelegate> delegate;
@property (assign, nonatomic) BOOL isInitialView;

@end

@implementation MagicWorldViewController

#pragma mark -
#pragma mark - LifeCycle

- (id)initWitFromRightAnimation:(BOOL)aBool isInitialView:(BOOL)isInitial delegate:(id)aDeleagate {
    self = [super init];
    if (self) {
        _isInitialView = isInitial;
        _delegate = aDeleagate;
        _fromRightToLeft = aBool;
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
    [self setupView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnimation];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)right:(id)sender {
    [self hideAnimationToRight];
    [self performSelector:@selector(righttWithDelay) withObject:nil afterDelay:kAnimationHide];
    
}


- (IBAction)left:(id)sender {
    [self hideAnimationToLeft];
    [self performSelector:@selector(leftWithDelay) withObject:nil afterDelay:kAnimationHide];
}


- (IBAction)magic:(id)sender {
    [self hideAnimationToRight];
    [self performSelector:@selector(magicWithDelay:) withObject:@([sender tag]) afterDelay:kAnimationHide];
}


- (IBAction)close:(id)sender {
    [Utils animationForAppear:NO forView:self.contentView];
    [self performSelector:@selector(close) withObject:nil afterDelay:kAnimationHide];
}


#pragma mark -
#pragma mark - Private Methods

- (void)close {
    [self.delegate close];
}


- (void)magicWithDelay:(NSNumber *)number {
    [self.delegate next:[number integerValue] isPrev:NO];
}


- (void)leftWithDelay {
    [self.delegate next:23 isPrev:YES];
}


- (void)righttWithDelay {
    [self.delegate next:1 isPrev:NO];
}


- (void)hideAnimationToRight {
    [Utils animationForAppear:NO fromRight:YES forView:self.contentView];
}


- (void)hideAnimationToLeft {
    [Utils animationForAppear:NO fromRight:NO forView:self.contentView];
}


- (void)setupView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize screenSize = CGSizeMake(CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
    changeSize(screenSize, self.view);
    self.popUpTitle.image = [UIImage imageWithName:@"29_title"];
    
    NSDictionary *frames = [NSDictionary dictionaryWithContentsOfURL:[NSURL urlForFrames]];
    for (NSString *key in frames) {
        NSDictionary *dict = @{@"tag" : key,
                               @"frame" : frames[key],
                               @"selector" : NSStringFromSelector(@selector(magic:)),
                               @"target" : self};
        MagicWorldPortrait *portrait = [[MagicWorldPortrait instantiate] initWithDict:dict];
        [self.contentView addSubview:portrait];
    }

}


- (void)startAnimation {
    if (self.isInitialView) {
        [Utils animationForAppear:YES forView:self.contentView];
    } else {
        [self.view setHidden:NO];
        [Utils animationForAppear:YES fromRight:self.fromRightToLeft forView:self.contentView];
    }
}

@end
