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
-(void)next:(int)pageToShow;
-(void)openBook;
@end
@interface PopUpViewController : UIViewController
+ (id)sharedManager;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, retain) id <PopUpDelegate> delegate;
@end
