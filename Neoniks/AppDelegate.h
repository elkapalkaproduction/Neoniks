//
//  AppDelegate.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogoViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) LogoViewController *viewController;
@end
