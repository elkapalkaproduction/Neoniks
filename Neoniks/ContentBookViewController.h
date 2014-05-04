//
//  ContentBookViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentBookViewController : UIViewController
- (id)initWithPageNumber:(NSInteger)page chapter:(NSInteger)chapter;
@property (assign, nonatomic) NSInteger chapter;
@property (assign, nonatomic) NSInteger page;
@end
