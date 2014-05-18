//
//  AllBookmarsViewController.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllBookmarksDelegate <NSObject>

- (void)bookmarksRequiredToShow:(NSInteger)page;

@end

@interface AllBookmarsViewController : UIViewController

@property (weak, nonatomic) id<AllBookmarksDelegate> delegate;

@end
