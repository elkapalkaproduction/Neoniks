//
//  ContentOfBookViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentOfBookDelegate <NSObject>
- (void)closeTableOfContents;
- (void)relaod;

@end

@interface TableOfContentsViewController : UIViewController
@property (weak, nonatomic) id <ContentOfBookDelegate> delegate;

@end
