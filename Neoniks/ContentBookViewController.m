//
//  ContentBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "ContentBookViewController.h"
#import "Utils.h"

@interface ContentBookViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end

@implementation ContentBookViewController
- (id)initWithPage:(PageDetails *)pageDetails {
    self = [super init];
    if (self) {
        _currentPage = pageDetails;
        NSString *pagePath = [NSString stringWithFormat:@"%d_%d", pageDetails.chapter, pageDetails.page];
        _url = [NSURL urlFromName:pagePath extension:@"html"];
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:urlRequest];
}


- (void)setCurrentPage:(PageDetails *)currentPage {
    _currentPage = currentPage;
    NSString *pagePath = [NSString stringWithFormat:@"%d_%d", currentPage.chapter, currentPage.page];
    self.url = [NSURL urlFromName:pagePath extension:@"html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:urlRequest];

}

@end
