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
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.navController pushViewController:logoViewController animated:NO];
    [self.navController setNavigationBarHidden:YES];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];    // Override point for customization after application launch.

    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([self.navController.topViewController isKindOfClass:[NewBookViewController class]]) {
        if (isIphone()) {
            return UIInterfaceOrientationMaskPortrait;
        } else {
            return UIInterfaceOrientationMaskAll;
        }
    }
    
    // Only allow portrait (standard behaviour)
    return UIInterfaceOrientationMaskLandscape;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [AdsManager logEvent:FLURRY_APP_CLOSED];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [AdsManager logEvent:FLURRY_APP_OPEN];
    [[AdsManager sharedManager] matDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
