//
//  BookmarksManager.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "BookmarksManager.h"
#import "Utils.h"
#import "ChaptersCollection.h"
#import "PageDetails.h"

NSString *const allBookmarks = @"allBookmarks";
NSString *const lastOpenPageKey = @"lastOpenPage";
NSString *const namedBookmarks = @"namedBookmarks";

NSString *const allBookmarksRus = @"allBookmarksRus";
NSString *const lastOpenPageKeyRus = @"lastOpenPageRus";
NSString *const namedBookmarksRus = @"namedBookmarksRus";

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
    NSMutableArray *bookmarks = [NSMutableArray arrayWithArray:[self allBookmarks]];

    if ([bookmarks containsObject:@(page)]) {
        [bookmarks removeObject:@(page)];
    } else {
        [bookmarks addObject:@(page)];
        ChaptersCollection *collection = [[ChaptersCollection alloc] init];
        PageDetails *pageDetails = [collection pageDetailsForNumber:page];
        NSString *unformattedString;
        if (isRussian()) {
            unformattedString = @"Глава: %d Страница: %d";
        } else {
            unformattedString = @"Chapter: %d Page: %d";
        }
        NSString *string = [[NSString alloc] initWithFormat:unformattedString, pageDetails.chapter, page * 2 - 1];
        [self updateNameStringForPage:page andName:string];
    }
    [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:[self getKey]];
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


- (void)updateNameStringForPage:(NSInteger)page andName:(NSString *)name {
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:[self namedKey]];
    NSMutableDictionary *bookmarks = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    bookmarks[[self generateKeyFromInt:page]] = name;
    [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:[self namedKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)generateKeyFromInt:(NSInteger)number {
    return [NSString stringWithFormat:@"page%ld", (long)number];
}


- (NSString *)nameStringForPage:(NSInteger)page {
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:[self namedKey]];

    return dictionary[[self generateKeyFromInt:page]];
}


- (NSArray *)allBookmarks {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self getKey]];
}


- (void)setLastOpen:(NSInteger)last {
    [[NSUserDefaults standardUserDefaults] setObject:@(last) forKey:[self getLastPageKey]];
}


- (NSInteger)lastOpen {
    NSString *key = [self getLastPageKey];

    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:key];
    }

    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue];
}


- (NSString *)getKey {
    NSString *key = allBookmarks;
    if (isRussian()) {
        key = allBookmarksRus;
    }

    return key;
}


- (NSString *)getLastPageKey {
    NSString *key = lastOpenPageKey;
    if (isRussian()) {
        key = lastOpenPageKeyRus;
    }

    return key;
}


- (NSString *)namedKey {
    NSString *key = namedBookmarks;
    if (isRussian()) {
        key = namedBookmarksRus;
    }

    return key;
}

@end
