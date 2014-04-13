//
//  ContentBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "ContentBookViewController.h"

@interface ContentBookViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;
@end

@implementation ContentBookViewController
- (id)initWithPageNumber:(NSInteger)page {
    self = [super init];
    if (self) {
        _url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%d.rus",page] withExtension:@"html"];


    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:urlRequest];
}

@end
