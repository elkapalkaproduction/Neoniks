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

@end

@implementation MagicWorldViewController

+ (id)sharedManager {
    static MagicWorldViewController *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if (IS_PHONE5) {
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
        for (UIButton *icon in _icons) {
            [icon setFrame:CGRectFromString([dict objectForKey:[NSString stringWithFormat:@"%ld",(long)[icon tag]]])];
        }

    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSString *)stringFromRectWithOrigin:(int)x :(int)y{
   return  NSStringFromCGRect(CGRectMake(x, y, 77, 85));
}
-(void)viewWillAppear:(BOOL)animated{
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);

    [super viewWillAppear:animated];
    for (UIButton *icon in _icons){
        [icon setImage:[Utils imageWithName:[NSString stringWithFormat:@"%ld_magic",(long)[icon tag]]] forState:UIControlStateNormal];
    }
    _popUpTitle.image = [Utils imageWithName:@"29_title"];

    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setHidden:NO];
    
    CALayer *adContentLayer = self.contentView.layer;
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = 1.0 / 1000;
    
    adContentLayer.transform = layerTransform;
    
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = kAnimationDuration;
    rotationY.fromValue = [NSNumber numberWithFloat:_fromRightToLeft? -M_PI_2:M_PI_2];
    rotationY.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = [NSNumber numberWithFloat:_fromRightToLeft? adContentLayer.frame.size.width:-adContentLayer.frame.size.width];
    translationX.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
    translationZ.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
    
}
-(void)hideAnimationToRight{
    CALayer *adContentLayer = self.contentView.layer;
    
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = 1.0 / 500;
    adContentLayer.transform = layerTransform;
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = kAnimationDuration;
    rotationY.fromValue = [NSNumber numberWithFloat:0];
    rotationY.toValue = [NSNumber numberWithFloat:- M_PI_2];
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = [NSNumber numberWithFloat:0];
    translationX.toValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width];
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = [NSNumber numberWithFloat:0];
    translationZ.toValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
}
-(void)hideAnimationToLeft{
    CALayer *adContentLayer = self.contentView.layer;
    
    CATransform3D layerTransform = CATransform3DIdentity;
    layerTransform.m34 = 1.0 / 500;
    adContentLayer.transform = layerTransform;
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationY.duration = kAnimationDuration;
    rotationY.fromValue = [NSNumber numberWithFloat:0];
    rotationY.toValue = [NSNumber numberWithFloat:M_PI_2];
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = [NSNumber numberWithFloat:0];
    translationX.toValue = [NSNumber numberWithFloat:-adContentLayer.frame.size.width];
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = [NSNumber numberWithFloat:0];
    translationZ.toValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
}

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
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:_delegate selector:@selector(closeWorld) userInfo:Nil repeats:NO];
}
-(void)magicWithDelay:(NSTimer *)userInfo{
    [userInfo userInfo];
    [_delegate show:(int)[[[userInfo userInfo] objectForKey:@"key"] integerValue]];
}
-(void)leftWithDelay{
    [_delegate next:23 isPrev:YES];
}
-(void)righttWithDelay{
    [_delegate next:1 isPrev:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
