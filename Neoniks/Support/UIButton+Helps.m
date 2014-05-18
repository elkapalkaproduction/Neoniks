//
//  UIButton+Helps.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "UIButton+Helps.h"

@implementation UIButton (Helpers)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

@end
