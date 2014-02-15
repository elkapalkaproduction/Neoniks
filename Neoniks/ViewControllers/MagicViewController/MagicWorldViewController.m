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
 
 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (int  i = 0; i<_icons.count; i++) {
        [_icons[i] setImage:[Utils imageWithName:[NSString stringWithFormat:@"%d_magic",[[_icons objectAtIndex:i] tag]]] forState:UIControlStateNormal];
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
    rotationY.fromValue = [NSNumber numberWithFloat:M_PI_2];
    rotationY.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:rotationY forKey:@"transform.rotation.y"];
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationX.duration = kAnimationDuration;
    translationX.fromValue = [NSNumber numberWithFloat:-adContentLayer.frame.size.width];
    translationX.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:translationX forKey:@"transform.translation.x"];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
    translationZ.duration = kAnimationDuration;
    translationZ.fromValue = [NSNumber numberWithFloat:adContentLayer.frame.size.width/2];
    translationZ.toValue = [NSNumber numberWithFloat:0];
    [adContentLayer addAnimation:translationZ forKey:@"transform.translation.z"];
    
}
-(void)hideAnimation{
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
- (IBAction)magic:(id)sender {
    [self hideAnimation];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(magicWithDelay:) userInfo:@{@"key": [NSNumber numberWithInt:[sender tag]]} repeats:NO];
}
- (IBAction)close:(id)sender {
    [self hideAnimation];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:_delegate selector:@selector(closeWorld) userInfo:Nil repeats:NO];
}
-(void)magicWithDelay:(NSTimer *)userInfo{
    [userInfo userInfo];
    [_delegate show:[[[userInfo userInfo] objectForKey:@"key"] integerValue]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
