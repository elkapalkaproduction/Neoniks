//
//  FlurryConfiguration.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 7/14/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "FlurryConfiguration.h"
#import "Flurry.h"

#ifdef Neoniks
NSString *const FLURRY_API_KEY = @"NWPDX6RG9S6ZGKBZBKRR";
#else
NSString *const FLURRY_API_KEY = @"794WTQPW9YR2P5WZNJ8N";
#endif
NSString *const FLURRY_APP_OPEN = @"App Open";
NSString *const FLURRY_APP_CLOSED = @"App Closed";
NSString *const FLURRY_BOOK_OPEN = @"Book Open";
NSString *const FLURRY_BOOK_CLOSED = @"Book Closed";
NSString *const FLURRY_LANGUAGE_CHANGED = @"Language Changed";
NSString *const FLURRY_MAP = @"Map Clicked";
NSString *const FLURRY_CHARACTER = @"Characters Clicked";
NSString *const FLURRY_POPUP_WINDOWS_ARROW = @"Pop-Up Window arrow clicked";
NSString *const FLURRY_CONTRIBUTORS = @"Contributors Clicked";
NSString *const FLURRY_MAKE_GIFT = @"Make a Gift Clicked";
NSString *const FLURRY_RATE_US = @"Rate Us Clicked";
NSString *const FLURRY_IN_APP_CLICKED = @"In-App is Clicked";
NSString *const FLURRY_IN_APP_MADE = @"In-App is Made";

@implementation FlurryConfiguration

+ (void)configure {
    [Flurry startSession:FLURRY_API_KEY];
}


+ (void)logEvent:(NSString *)eventName {
    [Flurry logEvent:eventName];
}

@end
