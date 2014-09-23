//
//  Utils.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "Utils.h"

#ifdef NeoniksFree
#import "MKStoreManager.h"
#endif
NSString *const kLanguage = @"PreferedLanguage";
NSString *const kRussianLanguageTag = @"ru";
NSString *const kEnglishLanguageTag = @"en";
NSString *const XFrom = @"XFrom";
NSString *const YFrom = @"YFrom";
NSString *const ZFrom = @"ZFrom";
NSString *const OpacityFrom = @"OpacityFrom";
NSString *const OpacityTo = @"OpacityTo";
NSString *const XTo = @"XTo";
NSString *const YTo = @"YTo";
NSString *const ZTo = @"ZTo";
NSString *const m34 = @"m34";
const CGFloat UtilsAnimationDuration = 0.8;
const NSInteger numberOfFreeChapters = 2;

@implementation Utils

+ (void)animationForAppear:(BOOL)show forView:(UIView *)aView withCompletionBlock:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:UtilsAnimationDuration / 2 animations:^{
        aView.alpha = show? 1.f : 0.f;
    } completion:completion];
}


+ (NSDictionary *)animationValuesForFrame:(CGRect)layerFrame fromRight:(BOOL)right toShow:(BOOL)show {
    NSInteger factor = right? 1 : -1;
    

    
    CGFloat m34Value = isIphone()? 1.0 / 750 : 1.0 / 1000;
  
    NSNumber *rotationYFromValue = show? @(-M_PI_2 * factor) : @0;
    NSNumber *rotationYToValue = show? @0 : @(-M_PI_2 * factor);
    
    NSNumber *rotationXFromValue = show? @(layerFrame.size.width * factor) : @0;
    NSNumber *rotationXToValue = show? @0 : @(layerFrame.size.width * factor);
    
    NSNumber *rotationZFromValue = show? @(layerFrame.size.width / 2) : @0;
    NSNumber *rotationZToValue = show? @0 : @(layerFrame.size.width / 2);
    NSNumber *opacityFrom = show? @0 : @1;
    NSNumber *opacityTo = show? @1 : @0;
    NSDictionary *dict = @{YFrom: rotationYFromValue,
                           XFrom: rotationXFromValue,
                           ZFrom: rotationZFromValue,
                           YTo: rotationYToValue,
                           XTo: rotationXToValue,
                           ZTo: rotationZToValue,
                           OpacityFrom: opacityFrom,
                           OpacityTo: opacityTo,
                           m34: @(m34Value)};
    
    return dict;
}


+ (void)swapValueWithFirstValue:(NSNumber *)number1 secondValue:(NSNumber *)number2 {
    NSNumber *number3 = number1;
    number1 = number2;
    number2 = number3;
}


+ (void)animationForLayer:(CALayer *)layer values:(NSDictionary *)animationValues {
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = UtilsAnimationDuration;
    rotationY.fromValue = animationValues[YFrom];
    rotationY.toValue = animationValues[YTo];
    [layer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = UtilsAnimationDuration;
    translationX.fromValue = animationValues[XFrom];
    translationX.toValue = animationValues[XTo];
    [layer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = UtilsAnimationDuration;
    translationZ.fromValue = animationValues[ZFrom];
    translationZ.toValue = animationValues[ZTo];
    [layer addAnimation:translationZ forKey:@"transform.translation.z"];
    
    layer.opacity = [animationValues[OpacityFrom] floatValue];
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.duration = UtilsAnimationDuration;
    alpha.fromValue = @(layer.opacity);
    layer.opacity = [animationValues[OpacityTo] floatValue];
    alpha.toValue = @(layer.opacity);
    [layer addAnimation:alpha forKey:@"opacity"];


}


+ (void)animationForAppear:(BOOL)show fromRight:(BOOL)aRight forView:(UIView *)aView withCompletionBlock:(void (^)(void))block {
    CALayer *adContentLayer = aView.layer;
    CGRect layerFrame = adContentLayer.frame;
    NSDictionary *animationValues = [self animationValuesForFrame:layerFrame fromRight:aRight toShow:show];
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = [animationValues[m34] floatValue];
    adContentLayer.transform = layerTransform;
    [CATransaction begin];
    {
        [CATransaction setCompletionBlock:block];
        [self animationForLayer:adContentLayer values:animationValues];
    }
    [CATransaction commit];
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
        isIphon5 = [Utils screenSize].height != 480 && isIphone();
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


+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    } else {
        return screenSize;
    }
}


#ifdef NeoniksFree
+ (BOOL)isLockedPage:(PageDetails *)page {
    return page.chapter > numberOfFreeChapters && ![MKStoreManager isFeaturePurchased:SUB_PRODUCT_ID];
}


#endif

@end
