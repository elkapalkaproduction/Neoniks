//
//  OpenUrlHandler.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 9/23/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenUrlHandler : NSObject

+ (instancetype)sharedHandler;
- (void)parsePlaces:(NSString *)place withNavigationController:(UINavigationController *)navigationController;
- (void)parseCharacters:(NSString *)character withNavigationController:(UINavigationController *)navigationController;
- (void)parseTraditions:(NSString *)tradition withNavigationController:(UINavigationController *)navigationController;

@end
