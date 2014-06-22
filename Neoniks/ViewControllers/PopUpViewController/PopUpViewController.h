//
//  PopUpViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpDelegate <NSObject>
- (void)close;
- (void)next:(NSInteger)pageToShow isPrev:(BOOL)prev;
- (void)openBook;

@end

@interface PopUpViewController : UIViewController
- (id)initWithPageNumber:(int)page fromRightAnimation:(BOOL)aBool delegate:(id)aDeletegate;

@end
