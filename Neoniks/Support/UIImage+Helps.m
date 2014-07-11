//
//  UIImage+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "UIImage+Helps.h"

@implementation UIImage (Helpers)

+ (UIImage *)imageWithName:(NSString *)name {
    if (!name) return nil;
    NSString *localizedString = [NSString neoniksLocalizedString:name];

    return [UIImage imageWithLocalizedName:localizedString];
}


+ (UIImage *)imageWithLocalizedName:(NSString *)name {
    if (!name) return nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];

    return [UIImage imageWithContentsOfFile:path];
}


+ (UIImage *)contributorsBackgroundImage {
    if (isIphone()) {
        if (isIphone5()) {
            return [UIImage imageNamed:@"fon_contributors_5"];
        } else {
            return [UIImage imageNamed:@"fon_contributors_4"];
        }
    } else {
        return [UIImage imageNamed:@"fon_contributors"];
    }
}

@end
