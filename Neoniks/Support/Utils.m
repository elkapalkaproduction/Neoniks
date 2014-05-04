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
+(NSURL *)urlFromName:(NSString *)name extension:(NSString *)extension {
    return [[NSBundle mainBundle] URLForResource:AVLocalizedSystem(name) withExtension:extension];
}
+(UIButton *)buttonWithFrame:(CGRect)rect tag:(int)tag image:(UIImage *)image target:(id)target selector:(SEL)selector{
    UIButton *button =[[UIButton alloc] initWithFrame:rect];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    return button;
}

+ (void)animationForAppear:(BOOL)show fromRight:(BOOL)aRight forView:(UIView *)aView{
    CALayer *adContentLayer = aView.layer;
    NSNumber *rotationYFromValue; NSNumber *rotationYToValue;
    NSNumber *rotationXFromValue; NSNumber *rotationXToValue;
    NSNumber *rotationZFromValue; NSNumber *rotationZToValue;
    CGFloat m34Value;
    if (show) {
        NSInteger factor;
        if (aRight) {
            factor = 1;
        } else {
            factor = -1;
        }
        rotationYFromValue = [NSNumber numberWithFloat:-M_PI_2 * factor];
        rotationXFromValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width * factor];
        rotationZFromValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
        rotationYToValue = [NSNumber numberWithFloat:0];
        rotationXToValue = [NSNumber numberWithFloat:0];
        rotationZToValue = [NSNumber numberWithFloat:0];
        m34Value = 1.0 / 1000;
    } else {
        NSInteger factor;
        if (aRight) {
            factor = 1;
        } else {
            factor = -1;
        }
        rotationYFromValue = [NSNumber numberWithFloat:0];
        rotationXFromValue = [NSNumber numberWithFloat:0];
        rotationZFromValue = [NSNumber numberWithFloat:0];
        rotationYToValue = [NSNumber numberWithFloat:-M_PI_2 * factor];
        rotationXToValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width * factor];
        rotationZToValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
        m34Value = 1.0 / 500;
    }
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = m34Value;
    adContentLayer.transform = layerTransform;
    
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = kAnimationDuration;
    rotationY.fromValue = rotationYFromValue;
    rotationY.toValue = rotationYToValue;
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = rotationXFromValue;
    translationX.toValue = rotationXToValue;
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = rotationZFromValue;
    translationZ.toValue = rotationZToValue;
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
}

@end
