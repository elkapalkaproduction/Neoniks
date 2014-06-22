//
//  ChapterDetails.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 6/8/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChapterDetails : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (assign, nonatomic) NSInteger numberOfPages;
@property (strong, nonatomic) NSString *chapterName;

@end
