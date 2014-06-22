//
//  ContentOfBookViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentOfBookDelegate <NSObject>
- (void)close;
- (void)relaod;

@end

@interface ContentOfBookViewController : UIViewController
@property (weak, nonatomic) id<ContentOfBookDelegate> delegate;

@end