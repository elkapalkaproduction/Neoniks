//
//  ContentBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "ContentBookViewController.h"
#import "Utils.h"

@interface ContentBookViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;
@end

@implementation ContentBookViewController
- (id)initWithPageNumber:(NSInteger)page chapter:(NSInteger)chapter{
    self = [super init];
    if (self) {
        NSString *pagePath = [NSString stringWithFormat:@"%d_%d",chapter,page];
        _chapter = chapter;
        _page = page;
        _url = [Utils urlFromName:pagePath extension:@"html"];


    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:urlRequest];
}

@end
