//
//  MagicWorldViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/15/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MagicWorldViewController.h"

@interface MagicWorldViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *popUpTitle;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *icons;
@property (nonatomic, assign) BOOL fromRightToLeft;
@property (nonatomic, weak) id <MagicWorldDelegate> delegate;

@end

@implementation MagicWorldViewController

#pragma mark -
#pragma mark - LifeCycle

- (id)initWitFromRightAnimation:(BOOL)aBool delegate:(id)aDeleagate {
    self =[super init];
    if (self) {
        _delegate = aDeleagate;
        _fromRightToLeft = aBool;
    }
    return self;
}


#pragma mark -
#pragma mark - ViewCycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    _popUpTitle.image = [Utils imageWithName:@"29_title"];
    
    NSDictionary *dict = [self framesForIphone5];
    for (UIButton *icon in _icons){
        [icon setImage:[Utils imageWithName:[NSString stringWithFormat:@"%ld_magic",(long)[icon tag]]] forState:UIControlStateNormal];
        if (IS_PHONE5) {
            [icon setFrame:CGRectFromString([dict objectForKey:[NSString stringWithFormat:@"%ld",(long)[icon tag]]])];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setHidden:NO];
    [Utils animationForAppear:YES fromRight:_fromRightToLeft forView:self.contentView];
}


- (void)hideAnimationToRight {
    [Utils animationForAppear:NO fromRight:YES forView:self.contentView];
}


- (void)hideAnimationToLeft {
    [Utils animationForAppear:NO fromRight:NO forView:self.contentView];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)right:(id)sender {
    [self hideAnimationToRight];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(righttWithDelay) userInfo:Nil repeats:NO];
    
}


- (IBAction)left:(id)sender {
    [self hideAnimationToLeft];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(leftWithDelay) userInfo:Nil repeats:NO];
}


- (IBAction)magic:(id)sender {
    [self hideAnimationToRight];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(magicWithDelay:) userInfo:@{@"key": [NSNumber numberWithInt:(int)[sender tag]]} repeats:NO];
}


- (IBAction)close:(id)sender {
    [self hideAnimationToRight];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:_delegate selector:@selector(close) userInfo:Nil repeats:NO];
}


#pragma mark -
#pragma mark - Private Methods

- (void)magicWithDelay:(NSTimer *)userInfo {
    [userInfo userInfo];
    [_delegate next:(int)[[[userInfo userInfo] objectForKey:@"key"] integerValue] isPrev:NO];
}


- (void)leftWithDelay {
    [_delegate next:23 isPrev:YES];
}


- (void)righttWithDelay {
    [_delegate next:1 isPrev:NO];
}

- (NSDictionary *)framesForIphone5 {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self stringFromRectWithOrigin:26 :64] forKey:@"19"];
    [dict setObject:[self stringFromRectWithOrigin:144 :64] forKey:@"17"];
    [dict setObject:[self stringFromRectWithOrigin:347 :64] forKey:@"18"];
    [dict setObject:[self stringFromRectWithOrigin:465 :64] forKey:@"7"];
    
    [dict setObject:[self stringFromRectWithOrigin:85 :140] forKey:@"26"];
    [dict setObject:[self stringFromRectWithOrigin:192 :140] forKey:@"9"];
    [dict setObject:[self stringFromRectWithOrigin:291 :140] forKey:@"27"];
    [dict setObject:[self stringFromRectWithOrigin:406 :140] forKey:@"28"];
    
    [dict setObject:[self stringFromRectWithOrigin:26 :216] forKey:@"8"];
    [dict setObject:[self stringFromRectWithOrigin:144 :216] forKey:@"3"];
    [dict setObject:[self stringFromRectWithOrigin:347 :216] forKey:@"11"];
    [dict setObject:[self stringFromRectWithOrigin:465 :216] forKey:@"21"];
    return dict;
}


- (NSString *)stringFromRectWithOrigin:(int)x :(int)y {
    return  NSStringFromCGRect(CGRectMake(x, y, 77, 85));
}

@end
