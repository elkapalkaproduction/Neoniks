//
//  OpenUrlHandler.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 9/23/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "OpenUrlHandler.h"
#import "MainViewController.h"

@implementation OpenUrlHandler

+ (instancetype)sharedHandler {
    
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (void)showPopUpWithTag:(NSInteger)tag navigationController:(UINavigationController *)navigationController {
    [navigationController popToRootViewControllerAnimated:NO];
    MainViewController *viewController = (MainViewController *)[navigationController topViewController];
    [viewController close];
    [viewController performSelector:@selector(showPopUpWithTag:) withObject:@10 afterDelay:1.f];
}

- (void)parseCharacters:(NSString *)character withNavigationController:(UINavigationController *)navigationController {
    if ([character isEqual:@"/phoebe"]) {
        [self showPopUpWithTag:17 navigationController:navigationController];
    } else if ([character isEqual:@"/mystie"]) {
        [self showPopUpWithTag:7 navigationController:navigationController];
    } else if ([character isEqual:@"/bubba"]) {
        [self showPopUpWithTag:10 navigationController:navigationController];

    }
}


- (void)parsePlaces:(NSString *)place withNavigationController:(UINavigationController *)navigationController {
    if ([place isEqualToString:@"/magicschool"]) {
        [self showPopUpWithTag:14 navigationController:navigationController];
    }
}


- (void)parseTraditions:(NSString *)tradition withNavigationController:(UINavigationController *)navigationController {
    if ([tradition isEqualToString:@"/halloween"]) {
        [self showPopUpWithTag:10 navigationController:navigationController];
    } else if ([tradition isEqualToString:@"/xmas"]) {
        [self showPopUpWithTag:10 navigationController:navigationController];
    }
}

@end
