//
//  Utils.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//
#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const kLanguage;
UIKIT_EXTERN NSString *const kRussianLanguageTag;
UIKIT_EXTERN NSString *const kEnglishLanguageTag;


#define kAnimationDuration 1
#define kAnimationHide kAnimationDuration/1.9

@interface Utils : NSObject

+ (void)animationForAppear:(BOOL)show fromRight:(BOOL)aRight forView:(UIView *)aView;
+ (void)setupLanguage;

void changePositon(CGPoint point, UIView *view);
void changeSize(CGSize size, UIView *view);

void setXFor(CGFloat x, UIView *view);
void setYFor(CGFloat y, UIView *view);

void changeWidth(CGFloat width, UIView *view);
void changeHeight(CGFloat height, UIView *view);

void moveViewHorizontalyWith(CGFloat x, UIView *view);
void moveViewVerticalyWith(CGFloat y, UIView *view);

BOOL isIphone5();
BOOL isIphone();

BOOL isRussian();
BOOL isEnglish();


void setRussianLanguage();
void setEnglishLanguage();

@end
