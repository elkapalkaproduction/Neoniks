//
//  ContentBookViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageDetails.h"
@protocol contentBookProtocol
- (void)hideOrShowSupportView;

@end

@interface ContentBookViewController : UIViewController
- (instancetype)initWithPage:(PageDetails *)pageDetails;

@property (weak, nonatomic) id<contentBookProtocol> delegate;

@property (strong, nonatomic) PageDetails *currentPage;

@end
