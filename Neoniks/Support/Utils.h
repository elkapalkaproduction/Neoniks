//
//  Utils.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "UIImage+Helps.h"
#import "NSURL+Helps.h"
#import "UIButton+Helps.h"
#import "AudioPlayer.h"
#import "PageDetails.h"

NSString *const kLanguage;
NSString *const kRussianLanguageTag;
NSString *const kEnglishLanguageTag;

const NSInteger numberOfFreeChapters;
#define SUB_PRODUCT_ID @"com.neoniks.free.unlock.fox"
#define kMaxIdleTimeSeconds 60.0 * 10

@interface Utils : NSObject

+ (void)animationForAppear:(BOOL)show forView:(UIView *)aView withCompletionBlock:(void (^)(BOOL finished))completion;
+ (void)animationForAppear:(BOOL)show fromRight:(BOOL)aRight forView:(UIView *)aView withCompletionBlock:(void (^)(void))block;
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

+ (CGSize)screenSize;

#ifdef NeoniksFree
+ (BOOL)isLockedPage:(PageDetails *)page;
#endif

@end
