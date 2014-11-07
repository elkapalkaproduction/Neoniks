//
//  NSString+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NSString+Helps.h"

@implementation NSString (Helpers)

+ (NSString *)neoniksLocalizedString:(NSString *)input {
    NSString *string = (NSString *)input;
    string = [NSString stringWithFormat:@"%@_%@", string, isRussian() ? @"rus":@"eng"];

    return string;
}


+ (NSString *)thisIsFreeLocalized {
    if (isRussian()) {
        return @" - БЕСПЛАТНО";
    } else {
        return @" - FREE";
    }
}


+ (NSString *)urlScheme {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSArray *CFBundleURLTypes = infoDictionary[@"CFBundleURLTypes"];
    NSDictionary *firstRow = CFBundleURLTypes[0];
    NSArray *CFBundleURLSchemes = firstRow[@"CFBundleURLSchemes"];

    return CFBundleURLSchemes[0];
}

@end
