//
//  BookmarksManager.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "BookmarksManager.h"
#import "Utils.h"


NSString * const allBookmarks = @"allBookmarks";
NSString * const lastOpenPageKey = @"lastOpenPage";

NSString * const allBookmarksRus = @"allBookmarksRus";
NSString * const lastOpenPageKeyRus = @"lastOpenPageRus";

@implementation BookmarksManager


+ (instancetype)sharedManager {
    static BookmarksManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)addOrRemoveBookmarkForPage:(NSInteger)page {
    NSString *key = allBookmarks;
    if (isRussian()) {
        key = allBookmarksRus;
    }
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    NSMutableArray *bookmarks = [NSMutableArray arrayWithArray:array];
    if (!bookmarks) {
        bookmarks = [[NSMutableArray alloc] init];
    }
    if ([bookmarks containsObject:@(page)]) {
        [bookmarks removeObject:@(page)];
    } else {
        [bookmarks addObject:@(page)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)bookmarkIsSaved:(NSInteger)page {
    NSString *key = allBookmarks;
    if (isRussian()) {
        key = allBookmarksRus;
    }

    NSMutableArray *bookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!bookmarks) {
        return NO;
    }
    return [bookmarks containsObject:@(page)];

}

- (NSArray *)allBookmarks {
    NSString *key = allBookmarks;
    if (isRussian()) {
        key = allBookmarksRus;
    }

    NSArray *bookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    return bookmarks;
}


- (void)setLastOpen:(NSInteger)last {
    NSString *key = lastOpenPageKey;
    if (isRussian()) {
        key = lastOpenPageKeyRus;
    }

    [[NSUserDefaults standardUserDefaults] setObject:@(last) forKey:key];
}


- (NSInteger)lastOpen {
    NSString *key = lastOpenPageKey;
    if (isRussian()) {
        key = lastOpenPageKeyRus;
    }

    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:key];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue];
}

@end
