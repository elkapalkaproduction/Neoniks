//
//  MagicWorldViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/15/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MagicWorldDelegate <NSObject>
-(void)closeWorld;
-(void)show:(int)pageToShow;
@end
@interface MagicWorldViewController : UIViewController
+ (id)sharedManager;
@property (nonatomic, retain) id <MagicWorldDelegate> delegate;

@end
