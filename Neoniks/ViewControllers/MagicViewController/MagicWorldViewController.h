//
//  MagicWorldViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/15/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MagicWorldDelegate <NSObject>
- (void)close;
- (void)next:(NSInteger)pageToShow isPrev:(BOOL)prev;

@end

@interface MagicWorldViewController : UIViewController
- (id)initWitFromRightAnimation:(BOOL)aBool delegate:(id)aDeleagate;

@end
