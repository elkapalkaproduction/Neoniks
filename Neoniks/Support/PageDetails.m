//
//  PageDetails.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/17/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PageDetails.h"

@implementation PageDetails

- (instancetype)initWithPage:(NSInteger)page chapter:(NSInteger)chapter {
    self = [super init];
    if (self) {
        _chapter = chapter;
        _page = page;
    }
    
    return self;
}

@end
