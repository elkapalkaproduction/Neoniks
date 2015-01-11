//
//  AppDelegate.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AppDelegate.h"
#import "AdsManager.h"
#import "OpenUrlHandler.h"
#import "MainViewController.h"
#import "LogoViewController.h"
#ifdef NeoniksFree
#import "MKStoreManager.h"
#endif
#import "NewBookViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSString *supportedURLScheme;
@property (strong, nonatomic) MainViewController *viewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Utils setupLanguage];
    AdsManager *adsManager = [AdsManager sharedManager];
    [adsManager configure];
#ifdef NeoniksFree
    NSLog(@"%@", [[MKStoreManager sharedManager] pricesDictionary]);
    [MKStoreManager sharedManager];
#endif
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    LogoViewController *logoViewController = [[LogoViewController alloc] initWithNibName:NSStringFromClass([LogoViewController class]) bundle:nil];
    self.viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.navController = [[MainNavigationController alloc] initWithRootViewController:self.viewController];
    [self.navController pushViewController:logoViewController animated:NO];
    [self.navController setNavigationBarHidden:YES];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];    // Override point for customization after application launch.

    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [AdsManager logEvent:FLURRY_APP_CLOSED];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [AdsManager logEvent:FLURRY_APP_OPEN];
    [[AdsManager sharedManager] matDidBecomeActive];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[url scheme] isEqualToString:self.supportedURLScheme]) {
        if ([[url host] isEqualToString:@"place"]) {
            [[OpenUrlHandler sharedHandler] parsePlaces:[url path]
                               withNavigationController:self.navController];
        } else if ([[url host] isEqualToString:@"traditions"]) {
            [[OpenUrlHandler sharedHandler] parseTraditions:[url path]
                                   withNavigationController:self.navController];
        } else if ([[url host] isEqualToString:@"character"]) {
            [[OpenUrlHandler sharedHandler] parseCharacters:[url path]
                                   withNavigationController:self.navController];
        }

        return YES;
    }
    [[AdsManager sharedManager] matOpenURL:url sourceApplication:sourceApplication];

    return YES;
}


- (NSString *)supportedURLScheme {
    if (!_supportedURLScheme) {
        _supportedURLScheme = [NSString urlScheme];
    }

    return _supportedURLScheme;
}

@end
