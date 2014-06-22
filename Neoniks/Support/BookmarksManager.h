//
//  BookmarksManager.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookmarksManager : NSObject

+ (instancetype)sharedManager;
- (void)addOrRemoveBookmarkForPage:(NSInteger)page;
- (BOOL)bookmarkIsSaved:(NSInteger)page;
- (NSArray *)allBookmarks;
- (void)setLastOpen:(NSInteger)last;
- (NSInteger)lastOpen;

@end
