//
//  ChaptersCollection.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 6/8/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "ChaptersCollection.h"

@interface ChaptersCollection ()

@property (strong, nonatomic) NSArray *chaptersEng;
@property (strong, nonatomic) NSArray *chaptersRus;

@end

@implementation ChaptersCollection

- (NSArray *)setupChapter:(NSURL *)chaptersUrl {
    NSArray *tmpChapters = [[NSArray alloc] initWithContentsOfURL:chaptersUrl];
    NSMutableArray *tmpMutableChapters = [[NSMutableArray alloc] init];
    for (int i = 0; i < tmpChapters.count; i++) {
        ChapterDetails *details = [[ChapterDetails alloc] initWithDictionary:tmpChapters[i]];
        [tmpMutableChapters addObject:details];
    }
    
    return [NSArray arrayWithArray:tmpMutableChapters];
}


- (NSArray *)setupChaptersEng {
    NSURL *chaptersUrl = [NSURL urlFromLocalizedName:@"chapters_eng" extension:@"plist"];
    
    return [self setupChapter:chaptersUrl];
    
}


- (NSArray *)setupChaptersRus {
    NSURL *chaptersUrl = [NSURL urlFromLocalizedName:@"chapters_rus" extension:@"plist"];
    
    return [self setupChapter:chaptersUrl];
}


- (NSArray *)chaptersEng {
    if (!_chaptersEng) {
        _chaptersEng = [self setupChaptersEng];
    }
    
    return _chaptersEng;
}


- (NSArray *)chaptersRus {
    if (!_chaptersRus) {
        _chaptersRus = [self setupChaptersRus];
    }
    
    return _chaptersRus;
}


- (NSArray *)chapters {
    if (isRussian()) {
        return self.chaptersRus;
    } else if (isEnglish()) {
        return self.chaptersEng;
    }
    
    return nil;
}


- (NSInteger)numberOfChapters {
    NSArray *chapters = [self chapters];
    
    return [chapters count];

}


- (NSInteger)numberOfPages {
    NSInteger number = 0;
    NSArray *chapters = [self chapters];
    for (ChapterDetails *details in chapters) {
        number += details.numberOfPages;
    }
    
    return number;
}


- (ChapterDetails *)chapterNumber:(NSInteger)number {
    
    NSArray *chapters = [self chapters];
    
    return chapters[number];
}


- (NSInteger)numberOfPagesInChapter:(NSInteger)number {
    return [self chapterNumber:number].numberOfPages;
}


- (NSInteger)numberForPageDetails:(PageDetails *)pageDetails {
    NSInteger number = pageDetails.page;
    NSInteger chapter = pageDetails.chapter - 1;
    for (int i = 0; i < chapter; i++) {
        number += [self numberOfPagesInChapter:i];
    }
    
    return number;
}


- (PageDetails *)pageDetailsForNumber:(NSInteger)number {
    NSInteger chapter = 0;
    NSInteger page = number;
    
    while ([self numberOfPagesInChapter:chapter] < page) {
        page -= [self numberOfPagesInChapter:chapter];
        chapter++;
    }
    PageDetails *pageDetail = [[PageDetails alloc] initWithPage:page chapter:chapter + 1];
    
    return pageDetail;
}

@end
