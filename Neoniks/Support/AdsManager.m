//
//  FlurryConfiguration.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 7/14/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AdsManager.h"
#import "Flurry.h"
#ifdef NeoniksFree
#import <AdColony/AdColony.h>
#import "Chartboost.h"
#import "PlayHavenSDK.h"
#import "MKStoreManager.h"
#endif

//-- Flurry Keys
#ifdef Neoniks
NSString *const FLURRY_API_KEY = @"NWPDX6RG9S6ZGKBZBKRR";
#else
NSString *const FLURRY_API_KEY = @"794WTQPW9YR2P5WZNJ8N";
#endif
NSString *const FLURRY_APP_OPEN = @"App Open";
NSString *const FLURRY_APP_CLOSED = @"App Closed";
NSString *const FLURRY_BOOK_OPEN = @"Book Open";
NSString *const FLURRY_BOOK_CLOSED = @"Book Closed";
NSString *const FLURRY_LANGUAGE_CHANGED = @"Language Changed";
NSString *const FLURRY_MAP = @"Map Clicked";
NSString *const FLURRY_CHARACTER = @"Characters Clicked";
NSString *const FLURRY_POPUP_WINDOWS_ARROW = @"Pop-Up Window arrow clicked";
NSString *const FLURRY_CONTRIBUTORS = @"Contributors Clicked";
NSString *const FLURRY_MAKE_GIFT = @"Make a Gift Clicked";
NSString *const FLURRY_RATE_US = @"Rate Us Clicked";

NSString *const FLURRY_IN_APP_CLICKED = @"In-App is Clicked";
NSString *const FLURRY_IN_APP_MADE = @"In-App is Made";

//--AdColony Keys
NSString *const ADCOLONY_APP_ID = @"app875c0dc398634608b4";
NSString *const ADCOLONY_ON_START = @"vz3a30a927e7e74eb8b6";
NSString *const ADCOLONY_ON_SAYS_NO = @"vzbbba406f98c646248e";
NSString *const ADCOLONY_ON_TIMER = @"vz9cd176a0b1d44f1ab6";

//--Chartboost Keys
NSString *const CHARTBOOST_APP_ID = @"53c3784989b0bb369fa48dfc";
NSString *const CHARTBOOST_APP_SIGNATURE = @"3e13a9dea3ca3488807936809582923ff57c6fa1";

//--PlayHaven Keys
NSString *const PLAYHAVEN_TOKEN = @"f3852eb5f94e44fa908cbdf8df83692c";
NSString *const PLAYHAVEN_SECRET = @"f6c1cb8db79a43f48db9ec9ea89c9176";
NSString *const PLAYHAVEN_GAME_ID = @"141362";
NSString *const PLAYHAVEN_PLACEMENT_ON_START = @"on_start";
NSString *const PLAYHAVEN_PLACEMENT_ON_SAYS_NO = @"on_in_app_no";
NSString *const PLAYHAVEN_PLACEMENT_ON_TIMER = @"on_timer";
#ifdef NeoniksFree

@interface AdsManager () <PHPublisherContentRequestDelegate>

@end
#endif

@implementation AdsManager

+ (instancetype)sharedManager {
    static AdsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      sharedMyManager = [[self alloc] init];
                  });

    return sharedMyManager;
}


- (void)configure {
    [Flurry startSession:FLURRY_API_KEY];
#ifdef NeoniksFree
    [self setupPlayHaven];
    [self setupChartboost];
#endif
}


+ (void)logEvent:(NSString *)eventName {
    [Flurry logEvent:eventName];
}


+ (void)showOnStartAds {
#ifdef NeoniksFree
    if ([MKStoreManager isFeaturePurchased:SUB_PRODUCT_ID]) {
        return;
    }
//    [AdColony playVideoAdForZone:ADCOLONY_ON_START withDelegate:nil];
//    [[Chartboost sharedChartboost] showInterstitial:CBLocationStartup];
//    [[PHPublisherContentRequest requestForApp:PLAYHAVEN_TOKEN
//                                       secret:PLAYHAVEN_SECRET
//                                    placement:PLAYHAVEN_PLACEMENT_ON_START
//                                     delegate:nil] send];
//
#endif
}


+ (void)showOnSaysNoAds {
#ifdef NeoniksFree
    if ([MKStoreManager isFeaturePurchased:SUB_PRODUCT_ID]) {
        return;
    }
    [AdColony playVideoAdForZone:ADCOLONY_ON_SAYS_NO withDelegate:nil];
    [[Chartboost sharedChartboost] showInterstitial:CBLocationStartup];
    [[PHPublisherContentRequest requestForApp:PLAYHAVEN_TOKEN
                                       secret:PLAYHAVEN_SECRET
                                    placement:PLAYHAVEN_PLACEMENT_ON_SAYS_NO
                                     delegate:nil] send];
#endif
}


+ (void)showOnTimerAds {
#ifdef NeoniksFree
    if ([MKStoreManager isFeaturePurchased:SUB_PRODUCT_ID]) {
        return;
    }
    [AdColony playVideoAdForZone:ADCOLONY_ON_TIMER withDelegate:nil];
    [[Chartboost sharedChartboost] showInterstitial:CBLocationStartup];
    [[PHPublisherContentRequest requestForApp:PLAYHAVEN_TOKEN
                                       secret:PLAYHAVEN_SECRET
                                    placement:PLAYHAVEN_PLACEMENT_ON_TIMER
                                     delegate:nil] send];
#endif
}


#ifdef NeoniksFree

- (void)setupAdColony {
    NSArray *adColonyZoneIDs = @[ADCOLONY_ON_START,
                                 ADCOLONY_ON_SAYS_NO,
                                 ADCOLONY_ON_TIMER];
    [AdColony configureWithAppID:ADCOLONY_APP_ID
                         zoneIDs:adColonyZoneIDs
                        delegate:nil
                         logging:YES];
}


- (void)setupChartboost {
    [Chartboost startWithAppId:CHARTBOOST_APP_ID appSignature:CHARTBOOST_APP_SIGNATURE delegate:nil];
}


- (void)setupPlayHaven {
    [[PHPublisherContentRequest requestForApp:PLAYHAVEN_TOKEN
                                       secret:PLAYHAVEN_SECRET
                                    placement:PLAYHAVEN_PLACEMENT_ON_START
                                     delegate:self] preload];
}


- (void)requestDidGetContent:(PHPublisherContentRequest *)request {
    [self setupAdColony];
}


- (void)request:(PHPublisherContentRequest *)request contentDidFailWithError:(NSError *)error {
    [self setupAdColony];
}


#endif

@end
