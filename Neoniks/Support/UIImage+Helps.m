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
    NSString *localizedString = [NSString neoniksLocalizedString:name];
    
    return [UIImage imageWithLocalizedName:localizedString];
}


+ (UIImage *)imageWithLocalizedName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    
    return [UIImage imageWithContentsOfFile:path];
    
}

@end
