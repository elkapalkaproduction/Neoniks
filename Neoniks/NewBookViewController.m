//
//  NewBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 1/11/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NewBookViewController.h"
#import "NNKEpubView.h"
#import "DejalActivityView.h"
#import "ChaptersViewController.h"
#import "CustomizationViewController.h"
#import <WYPopoverController.h>

@interface NewBookViewController () <NNKEpubViewDelegate, ChaptersListDelegate, CustomizationDelegate>

@property (weak, nonatomic) IBOutlet NNKEpubView *epubView;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) WYPopoverController *popover;
@property (assign, nonatomic) BOOL beforePaginationHiddingState;

@end

@implementation NewBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *epubFilepath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"epub"];
    self.epubView.delegate = self;
    [self.epubView loadEpub:epubFilepath];

    // Do any additional setup after loading the view from its nib.
}


- (void)showOrHideMenu {
    self.topBar.hidden = !self.topBar.hidden;
    self.slider.hidden = self.topBar.hidden;
}


- (void)paginationDidStart {
    self.beforePaginationHiddingState = self.topBar.hidden;
    self.topBar.hidden = self.slider.hidden = YES;
    self.epubView.hidden = YES;
    [DejalActivityView activityViewForView:self.view];
}


- (void)paginationDidFinish {
    self.topBar.hidden = self.slider.hidden = self.beforePaginationHiddingState;
    self.epubView.hidden = NO;
    [DejalActivityView removeView];
}


- (void)pageDidChange {
    self.label.text = [NSString stringWithFormat:@"%lu/%lu",
                       (unsigned long)self.epubView.currentPageNumber,
                       (unsigned long)self.epubView.totalPagesCount];
    self.slider.value = (float)self.epubView.currentPageNumber / (float)self.epubView.totalPagesCount;
}


- (void)didSelectChapter:(NNKChapter *)chapter {
    [self.epubView loadSpine:chapter.chapterIndex atPageIndex:0];
    [self.popover dismissPopoverAnimated:YES];
}


- (void)didChangeFontToFontWithName:(NSString *)fontName {
    self.epubView.fontName = fontName;
    [self.popover dismissPopoverAnimated:YES];
}


- (void)didChangeBackgroundColorToColor:(NSString *)color {
    if ([color isEqualToString:@"white"]) {
        self.label.textColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor whiteColor];
    } else if ([color isEqualToString:@"black"]) {
        self.label.textColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.label.textColor = [UIColor blackColor];
        self.view.backgroundColor = [self colorWithHexString:color];
    }
    [self.epubView changeColorToColor:color];
    [self.popover dismissPopoverAnimated:YES];
}


- (IBAction)finishChangingValue:(id)sender {
    self.epubView.currentPageNumber = self.slider.value * self.epubView.totalPagesCount;
}


- (IBAction)valueChanged:(id)sender {
    NSUInteger currentPage = self.slider.value * self.epubView.totalPagesCount;
    self.label.text = [NSString stringWithFormat:@"%lu/%lu",
                       (unsigned long)currentPage,
                       (unsigned long)self.epubView.totalPagesCount];
}


- (IBAction)decrease:(id)sender {
    [self.epubView decreaseTextSize];
}


- (IBAction)increase:(id)sender {
    [self.epubView increaseTextSize];
}


- (IBAction)chapters:(UIButton *)sender {
    ChaptersViewController *viewController = [[ChaptersViewController alloc] initWithNibName:NSStringFromClass([ChaptersViewController class])
                                                                                      bundle:nil];
    viewController.delegate = self;
    viewController.chaptersList = self.epubView.chapters;
    self.popover = [[WYPopoverController alloc] initWithContentViewController:viewController];
    CGRect rect = sender.frame;
    rect.origin.y += sender.superview.frame.origin.y;
    rect.origin.x += sender.superview.frame.origin.x;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}


- (IBAction)customization:(UIButton *)sender {
    CustomizationViewController *viewController = [[CustomizationViewController alloc] initWithNibName:NSStringFromClass([CustomizationViewController class])
                                                                                                bundle:nil];
    viewController.delegate = self;

    self.popover = [[WYPopoverController alloc] initWithContentViewController:viewController];
    CGRect rect = sender.frame;
    rect.origin.y += sender.superview.frame.origin.y;
    rect.origin.x += sender.superview.frame.origin.x;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];

    CGFloat alpha, red, blue, green;
    alpha = 1.0f;
    red   = [self colorComponentFrom:colorString start:0 length:2];
    green = [self colorComponentFrom:colorString start:2 length:2];
    blue  = [self colorComponentFrom:colorString start:4 length:2];

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


- (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];

    return hexComponent / 255.0;
}

@end
