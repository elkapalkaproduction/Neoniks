//
//  UIButton+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "UIButton+Helps.h"

@implementation UIButton (Helpers)

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

@end
