//
//  NSURL+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "NSURL+Helps.h"
#import "NSString+Helps.h"
#import "Utils.h"

@implementation NSURL (Helpers)

+ (NSURL *)urlFromName:(NSString *)name extension:(NSString *)extension {
    NSString *localizedString = [NSString neoniksLocalizedString:name];
    
    return [NSURL urlFromLocalizedName:localizedString extension:extension];
}


+ (NSURL *)urlFromLocalizedName:(NSString *)name extension:(NSString *)extension {
    return [[NSBundle mainBundle] URLForResource:name withExtension:extension];
}


+ (NSURL *)urlForFrames {
    NSURL *url;
    if (isIphone()) {
        url = [NSURL urlFromLocalizedName:@"iphoneFrames" extension:@"plist"];
    } else {
        url = [NSURL urlFromLocalizedName:@"ipadFrames" extension:@"plist"];
    }
    
    return url;
}

@end
