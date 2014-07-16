//
//  FlurryConfiguration.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 7/14/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const FLURRY_APP_OPEN;
NSString *const FLURRY_APP_CLOSED;
NSString *const FLURRY_BOOK_OPEN;
NSString *const FLURRY_BOOK_CLOSED;
NSString *const FLURRY_LANGUAGE_CHANGED;
NSString *const FLURRY_MAP;
NSString *const FLURRY_CHARACTER;
NSString *const FLURRY_POPUP_WINDOWS_ARROW;
NSString *const FLURRY_CONTRIBUTORS;
NSString *const FLURRY_MAKE_GIFT;
NSString *const FLURRY_RATE_US;
NSString *const FLURRY_IN_APP_CLICKED;
NSString *const FLURRY_IN_APP_MADE;

@interface AdsManager : NSObject

+ (instancetype)sharedManager;
- (void)configure;
+ (void)logEvent:(NSString *)eventName;
- (void)showOnStartAds;
- (void)showOnSaysNoAds;
- (void)showOnTimerAds;

@end
