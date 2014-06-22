//
//  ChaptersCollection.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 6/8/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterDetails.h"
#import "PageDetails.h"

@interface ChaptersCollection : NSObject

- (NSInteger)numberOfChapters;
- (NSInteger)numberOfPages;
- (ChapterDetails *)chapterNumber:(NSInteger)number;
- (NSInteger)numberOfPagesInChapter:(NSInteger)number;

- (NSInteger)numberForPageDetails:(PageDetails *)pageDetails;
- (PageDetails *)pageDetailsForNumber:(NSInteger)number;

@end
