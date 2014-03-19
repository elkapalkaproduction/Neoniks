//
//  PopUpViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpDelegate <NSObject>
-(void)close;
-(void)next:(int)pageToShow isPrev:(BOOL)prev;
-(void)openBook;
@end
@interface PopUpViewController : UIViewController
+ (id)sharedManager;
@property (nonatomic, assign) int curentPage;
@property (nonatomic, assign) BOOL fromRightToLeft;
@property (nonatomic, strong) id <PopUpDelegate> delegate;
@end
