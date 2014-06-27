//
//  MagicWorldPortrait.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 6/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicWorldPortrait : UIView
+ (instancetype)instantiate;
- (void)addTarget:(id)target action:(SEL)action tag:(NSInteger)tag;

@property (assign, nonatomic) NSInteger characterId;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end
