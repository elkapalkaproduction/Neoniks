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

@interface NewBookViewController () <NNKEpubViewDelegate>

@property (weak, nonatomic) IBOutlet NNKEpubView *epubView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation NewBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *epubFilepath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"epub"];
    self.epubView.delegate = self;
    [self.epubView loadEpub:epubFilepath];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)paginationDidStart {
    self.epubView.hidden = YES;
    [DejalActivityView activityViewForView:self.view];
}


- (void)paginationDidFinish {
    self.epubView.hidden = NO;
    [DejalActivityView removeView];
}


- (IBAction)arial:(id)sender {
    self.epubView.fontName = @"Arial";
}


- (IBAction)timesNewRoman:(id)sender {
    self.epubView.fontName = @"Times New Roman";
}


- (IBAction)courier:(id)sender {
    self.epubView.fontName = @"Courier";
}


- (IBAction)decrease:(id)sender {
    [self.epubView decreaseTextSize];
}


- (IBAction)increase:(id)sender {
    [self.epubView increaseTextSize];
}


- (IBAction)chapters:(id)sender {
    
}


- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSUInteger)supportedInterfaceOrientations {
    if (isIphone()) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
    
}

@end
