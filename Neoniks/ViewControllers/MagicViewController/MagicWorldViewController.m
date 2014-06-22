//
//  MagicWorldViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/15/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MagicWorldViewController.h"

@interface MagicWorldViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *popUpTitle;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *icons;
@property (nonatomic, assign) BOOL fromRightToLeft;
@property (nonatomic, weak) id <MagicWorldDelegate> delegate;

@end

@implementation MagicWorldViewController

#pragma mark -
#pragma mark - LifeCycle

- (id)initWitFromRightAnimation:(BOOL)aBool delegate:(id)aDeleagate {
    self = [super init];
    if (self) {
        _delegate = aDeleagate;
        _fromRightToLeft = aBool;
    }
    
    return self;
}


#pragma mark -
#pragma mark - ViewCycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setHidden:NO];
    [Utils animationForAppear:YES fromRight:self.fromRightToLeft forView:self.contentView];
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
    [self hideAnimationToRight];
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
    NSDictionary *iphone5Frames;
    if (isIphone5()) {
        NSURL *url = [NSURL urlFromName:@"ihpone5Frames" extension:@"plist"];
        iphone5Frames = [NSDictionary dictionaryWithContentsOfURL:url];
    }
    for (UIButton *icon in self.icons) {
        NSString *iconName = [NSString stringWithFormat:@"%ld_magic", (long)[icon tag]];
        [icon setImage:[UIImage imageWithName:iconName]];
        if (isIphone5()) {
            NSString *key = [NSString stringWithFormat:@"%ld", (long)[icon tag]];
            NSString *string = iphone5Frames[key];
            [icon setFrame:CGRectFromString(string)];
        }
    }

}

@end
