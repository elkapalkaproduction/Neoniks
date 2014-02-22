//
//  Utils.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(UIImage *)imageWithName:(NSString *)name{
   return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:AVLocalizedSystem(name) ofType:@"png"]];
}
+(UIButton *)buttonWithFrame:(CGRect)rect tag:(int)tag image:(UIImage *)image target:(id)target selector:(SEL)selector{
    UIButton *button =[[UIButton alloc] initWithFrame:rect];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    return button;
}
@end
