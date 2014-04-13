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
@property (strong, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *popUpBackground;
@property (weak, nonatomic) IBOutlet UIImageView *popUpTitle;
@property (weak, nonatomic) IBOutlet UIImageView *learnMoreImage;
@property (weak, nonatomic) IBOutlet UIImageView *popUpArtImage;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (nonatomic, assign) int curentPage;
@property (nonatomic, assign) BOOL fromRightToLeft;
@property (nonatomic, weak) id <PopUpDelegate> delegate;
@end

@implementation PopUpViewController

#pragma mark -
#pragma mark - LifeCycle

- (id)initWithPageNumber:(int)page fromRightAnimation:(BOOL)aBool delegate:(id)aDeletegate {
    self = [super init];
    if (self) {
        _curentPage = page;
        _fromRightToLeft = aBool;
        _delegate = aDeletegate;
    }
    return self;
}


#pragma mark -
#pragma mark - ViewCycle

- (void)viewWillAppear:(BOOL)animated {
    
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
    [_galleryButton setImage:[Utils imageWithName:@"gallery"] forState:UIControlStateNormal];
    [_yesButton setImage:[Utils imageWithName:@"yes"] forState:UIControlStateNormal];
    
    _popUpTitle.image = [Utils imageWithName:[NSString stringWithFormat:@"%d_title",_curentPage]];
    nextPage = [[[[self nextPages] objectForKey:[NSString stringWithFormat:@"%d",_curentPage]] objectForKey:@"nextPage"] intValue];
    prevPage = [[[[self nextPages] objectForKey:[NSString stringWithFormat:@"%d",_curentPage]] objectForKey:@"previousPage"] intValue];
    _galleryButton.hidden = ![[[[self nextPages] objectForKey:[NSString stringWithFormat:@"%d",_curentPage]] objectForKey:@"isCharacter"] boolValue];
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
    [Utils animationForAppear:YES fromRight:_fromRightToLeft forView:self.contentView];

    CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)];
    _textView.frame = CGRectMake(_textView.frame.origin.x, 0.558*[UIScreen mainScreen].bounds.size.width-textViewSize.height/2, _textView.frame.size.width, textViewSize.height);

}


#pragma mark -
#pragma mark - Custom Getters

- (NSDictionary *)nextPages {
    if (nextPages == nil) {
        nextPages = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nextPages" ofType:@"plist"]];
    }
    return nextPages;
}


#pragma mark -
#pragma mark - IBActions

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


- (IBAction)goToGallery:(id)sender {
    nextPage = 29;
    [self right:nil];
}


- (IBAction)close:(id)sender {
    [self hideAnimationToRight];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:_delegate selector:@selector(close) userInfo:Nil repeats:NO];
}


- (IBAction)right:(id)sender {
    [self hideAnimationToRight];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(righttWithDelay) userInfo:Nil repeats:NO];

}


- (IBAction)left:(id)sender {
    [self hideAnimationToLeft];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(leftWithDelay) userInfo:Nil repeats:NO];
}


- (IBAction)yesButton:(id)sender {
    [self hideAnimationToRight];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationHide target:self selector:@selector(yesWithDelay) userInfo:Nil repeats:NO];
}


#pragma mark -
#pragma mark - Private Methods

- (void)yesWithDelay {
    [_delegate openBook];
}


- (void)leftWithDelay {
    [_delegate next:prevPage isPrev:YES];
}


- (void)righttWithDelay {
    [_delegate next:nextPage isPrev:NO];
}


- (void)hideAnimationToRight {
    [Utils animationForAppear:NO fromRight:YES forView:self.contentView];
}


- (void)hideAnimationToLeft {
    [Utils animationForAppear:NO fromRight:NO forView:self.contentView];
}

@end
