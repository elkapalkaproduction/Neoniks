//
//  PopUpViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController (){
    NSDictionary *nextPages;
    int nextPage;
    int prevPage;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *popUpBackground;
@property (weak, nonatomic) IBOutlet UIImageView *popUpTitle;
@property (weak, nonatomic) IBOutlet UIImageView *learnMoreImage;
@property (weak, nonatomic) IBOutlet UIImageView *popUpArtImage;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;

@end

@implementation PopUpViewController

+ (id)sharedManager {
    static PopUpViewController *sharedMyManager = nil;
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
- (IBAction)pinchGesture:(id)sender {
    UIPinchGestureRecognizer *gestureRecognizer = (UIPinchGestureRecognizer *)sender;
    
    NSLog(@"*** Pinch: Scale: %f Velocity: %f", gestureRecognizer.scale, gestureRecognizer.velocity);
    
	UIFont *font = self.textView.font;
	CGFloat pointSize = font.pointSize;
	NSString *fontName = font.fontName;
    
	pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize;
	
	if (pointSize < 13) pointSize = 13;
	if (pointSize > 42) pointSize = 42;
	
	self.textView.font = [UIFont fontWithName:fontName size:pointSize];
	
	// Save the new font size in the user defaults.
    // (UserDefaults is my own wrapper around NSUserDefaults.)
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:pointSize] forKey:@"fontSizeIphone"];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(NSDictionary *)nextPages{
    if (nextPages == nil) {
        nextPages = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nextPages" ofType:@"plist"]];
    }
    return nextPages;
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    [super viewWillAppear:animated];
    _textView.text = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:AVLocalizedSystem(@"texts") ofType:@"plist"]] objectForKey:[NSString stringWithFormat:@"%d",_curentPage]];
    _textView.textAlignment = NSTextAlignmentJustified;
    _textView.font = [UIFont fontWithName:@"Georgia" size:IS_PHONE? IS_PHONE5?10:8.5:18];
//    if (IS_PHONE && [[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSizeIphone"] floatValue]>0) {
//        _textView.font = [UIFont fontWithName:@"Georgia" size:[[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSizeIphone"] floatValue]];
//
//    }
    _popUpArtImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d_popup_art",_curentPage] ofType:@"png"]];
    _learnMoreImage.image = [Utils imageWithName:@"learn_more"];
    [_yesButton setImage:[Utils imageWithName:@"yes"] forState:UIControlStateNormal];
    
    _popUpTitle.image = [Utils imageWithName:[NSString stringWithFormat:@"%d_title",_curentPage]];
    nextPage = [[[[self nextPages] objectForKey:[NSString stringWithFormat:@"%d",_curentPage]] objectForKey:@"nextPage"] intValue];
    prevPage = [[[[self nextPages] objectForKey:[NSString stringWithFormat:@"%d",_curentPage]] objectForKey:@"previousPage"] intValue];
    _leftButton.hidden = prevPage == 0;
    _rightButton.hidden = nextPage == 0;
    if (_curentPage != 24 && _curentPage != 25) {
        _popUpArtImage.frame = CGRectMake(IS_PHONE?68:112, _popUpArtImage.frame.origin.y, _popUpArtImage.frame.size.width, _popUpArtImage.frame.size.height);
        _textView.frame = CGRectMake(IS_PHONE?230:522, _textView.frame.origin.y, _textView.frame.size.width, _textView.frame.size.height);
    } else {
        _popUpArtImage.frame = CGRectMake(IS_PHONE?IS_PHONE5?357:300:522, _popUpArtImage.frame.origin.y, _popUpArtImage.frame.size.width, _popUpArtImage.frame.size.height);
        _textView.frame = CGRectMake(IS_PHONE?68:112, _textView.frame.origin.y, _textView.frame.size.width, _textView.frame.size.height);

    }

    
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
    _textView.frame = CGRectMake(_textView.frame.origin.x, 0.558*[UIScreen mainScreen].bounds.size.width-_textView.contentSize.height/2, _textView.frame.size.width, _textView.contentSize.height);

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
- (IBAction)close:(id)sender {
    [self hideAnimation];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:_delegate selector:@selector(close) userInfo:Nil repeats:NO];
}
- (IBAction)right:(id)sender {
    [self hideAnimation];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(righttWithDelay) userInfo:Nil repeats:NO];

}
- (IBAction)left:(id)sender {
    [self hideAnimation];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(leftWithDelay) userInfo:Nil repeats:NO];
}
- (IBAction)yesButton:(id)sender {
    [self hideAnimation];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(yesWithDelay) userInfo:Nil repeats:NO];
}

-(void)yesWithDelay{
    [_delegate openBook];
}
-(void)leftWithDelay{
    [_delegate next:prevPage];
}
-(void)righttWithDelay{
    [_delegate next:nextPage];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
