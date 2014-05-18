//
//  PageDetails.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/17/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageDetails : NSObject

- (instancetype)initWithPage:(NSInteger)page chapter:(NSInteger)chapter;

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger chapter;

@end
