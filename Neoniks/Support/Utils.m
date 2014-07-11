//
//  Utils.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "Utils.h"

NSString *const kLanguage = @"PreferedLanguage";
NSString *const kRussianLanguageTag = @"ru";
NSString *const kEnglishLanguageTag = @"en";

@implementation Utils

+ (void)animationForAppear:(BOOL)show forView:(UIView *)aView {
    if (show) {
        [UIView animateWithDuration:1 animations:^{
             aView.alpha = 1.f;
         }];
    } else {
        [UIView animateWithDuration:1 animations:^{
             aView.alpha = 0.f;
         }];
    }
}


+ (void)animationForAppear:(BOOL)show fromRight:(BOOL)aRight forView:(UIView *)aView {
    CALayer *adContentLayer = aView.layer;
    NSNumber *rotationYFromValue; NSNumber *rotationYToValue;
    NSNumber *rotationXFromValue; NSNumber *rotationXToValue;
    NSNumber *rotationZFromValue; NSNumber *rotationZToValue;
    CGFloat m34Value;
    if (show) {
        NSInteger factor;
        if (aRight) {
            factor = 1;
        } else {
            factor = -1;
        }
        rotationYFromValue = [NSNumber numberWithFloat:-M_PI_2 * factor];
        rotationXFromValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width * factor];
        rotationZFromValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width / 2];
        rotationYToValue = [NSNumber numberWithFloat:0];
        rotationXToValue = [NSNumber numberWithFloat:0];
        rotationZToValue = [NSNumber numberWithFloat:0];
        m34Value = 1.0 / 1000;
    } else {
        NSInteger factor;
        if (aRight) {
            factor = 1;
        } else {
            factor = -1;
        }
        rotationYFromValue = [NSNumber numberWithFloat:0];
        rotationXFromValue = [NSNumber numberWithFloat:0];
        rotationZFromValue = [NSNumber numberWithFloat:0];
        rotationYToValue = [NSNumber numberWithFloat:-M_PI_2 * factor];
        rotationXToValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width * factor];
        rotationZToValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width / 2];
        m34Value = 1.0 / 500;
    }
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = m34Value;
    adContentLayer.transform = layerTransform;

    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = kAnimationDuration;
    rotationY.fromValue = rotationYFromValue;
    rotationY.toValue = rotationYToValue;
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];

    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = rotationXFromValue;
    translationX.toValue = rotationXToValue;
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];

    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = rotationZFromValue;
    translationZ.toValue = rotationZToValue;
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
}


+ (void)setupLanguage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults stringForKey:kLanguage]) {
        NSString *preferredLanguage = [NSLocale preferredLanguages][0];
        preferredLanguage = [preferredLanguage isEqualToString:kRussianLanguageTag] ? kRussianLanguageTag : kEnglishLanguageTag;
        [userDefaults setObject:preferredLanguage forKey:kLanguage];
    }
}


void changePositon(CGPoint point, UIView *view) {
    CGRect frame = view.frame;
    frame.origin = point;
    view.frame = frame;
}


void changeSize(CGSize size, UIView *view) {
    CGRect frame = view.frame;
    frame.size = size;
    view.frame = frame;
}


void setXFor(CGFloat x, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}


void setYFor(CGFloat y, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}


void changeWidth(CGFloat width, UIView *view) {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}


void changeHeight(CGFloat height, UIView *view) {
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}


void moveViewHorizontalyWith(CGFloat x, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.x += x;
    view.frame = frame;
}


void moveViewVerticalyWith(CGFloat y, UIView *view) {
    CGRect frame = view.frame;
    frame.origin.y += y;
    view.frame = frame;
}


BOOL isIphone5() {
    static BOOL isIphon5;
    static BOOL isInitialized = NO;
    if (!isInitialized) {
        isIphon5 = [UIScreen mainScreen].bounds.size.height == 568;
        isInitialized = YES;
    }

    return isIphon5;
}


BOOL isIphone() {
    static BOOL isIphon5;
    static BOOL isInitialized = NO;
    if (!isInitialized) {
        isIphon5 = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
        isInitialized = YES;
    }

    return isIphon5;
}


BOOL isRussian() {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];

    return [savedLanguage isEqualToString:kRussianLanguageTag];
}


BOOL isEnglish() {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];

    return [savedLanguage isEqualToString:kEnglishLanguageTag];
}


void setRussianLanguage() {
    [[NSUserDefaults standardUserDefaults] setObject:kRussianLanguageTag forKey:kLanguage];
}


void setEnglishLanguage() {
    [[NSUserDefaults standardUserDefaults] setObject:kEnglishLanguageTag forKey:kLanguage];
}

@end
