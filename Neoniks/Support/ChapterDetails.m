//
//  ChapterDetails.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 6/8/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "ChapterDetails.h"

@implementation ChapterDetails

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _numberOfPages = [dict[@"pages"] integerValue];
        _chapterName = dict[@"name"];
    }

    return self;
}

@end
