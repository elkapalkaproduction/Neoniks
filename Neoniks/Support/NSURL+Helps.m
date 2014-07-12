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


+ (NSURL *)urlForSite {
    if (isRussian()) {
        return [NSURL URLWithString:@"http://www.neoniki.ru"];
    } else {
        return [NSURL URLWithString:@"http://www.neoniks.com"];
    }
}


+ (NSURL *)rateAppWithID:(NSString *)appId {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", appId]];
}

@end
