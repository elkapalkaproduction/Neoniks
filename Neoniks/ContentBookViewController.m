//
//  ContentBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "ContentBookViewController.h"
#ifdef NeoniksFree
#import "Utils.h"
#import "MKStoreManager.h"
#import "SVProgressHUD.h"
#import "AdsManager.h"
#endif

@interface ContentBookViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *lockImage;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end

@implementation ContentBookViewController
- (id)initWithPage:(PageDetails *)pageDetails {
    self = [super init];
    if (self) {
        _currentPage = pageDetails;
    }

    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.currentPage = self.currentPage;
#ifdef NeoniksFree
    [self updateLocalization];
    [self addActionsToButtons];
#endif
}


- (void)setCurrentPage:(PageDetails *)currentPage {
    _currentPage = currentPage;
#ifdef NeoniksFree
    if ([Utils isLockedPage:currentPage]) {
        self.webView.hidden = YES;
        self.lockImage.hidden = self.restoreButton.hidden = self.buyButton.hidden = NO;

        return;
    } else {
        self.lockImage.hidden = self.restoreButton.hidden = self.buyButton.hidden = YES;
        self.webView.hidden = NO;
    }
#endif
    NSString *pagePath = [NSString stringWithFormat:@"%ld_%ld", (long)currentPage.chapter, (long)currentPage.page];
    self.url = [NSURL urlFromName:pagePath extension:@"html"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:urlRequest];
}


- (IBAction)tapGesture:(id)sender {
    [self.delegate hideOrShowSupportView];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#ifdef NeoniksFree

- (void)updateLocalization {
    if (isEnglish()) {
        [self.buyButton setTitle:@"Continue..." forState:UIControlStateNormal];
        [self.restoreButton setTitle:@"Restore" forState:UIControlStateNormal];
    } else {
        [self.buyButton setTitle:@"Продолжить..." forState:UIControlStateNormal];
        [self.restoreButton setTitle:@"Восстановить" forState:UIControlStateNormal];
    }
}


- (void)addActionsToButtons {
    [self.buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    [self.restoreButton addTarget:self action:@selector(restore:) forControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)buy:(id)sender {
    [SVProgressHUD show];
    [AdsManager logEvent:FLURRY_IN_APP_CLICKED];
    [[MKStoreManager sharedManager] buyFeature:SUB_PRODUCT_ID onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt)
     {
         [SVProgressHUD dismiss];
         [AdsManager logEvent:FLURRY_IN_APP_MADE];

         self.currentPage = self.currentPage;
     }


                                   onCancelled:^
     {
         [SVProgressHUD dismiss];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
}


- (IBAction)restore:(id)sender {
    [SVProgressHUD show];
    [AdsManager logEvent:FLURRY_IN_APP_CLICKED];
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
         [SVProgressHUD dismiss];
         self.currentPage = self.currentPage;
         [AdsManager logEvent:FLURRY_IN_APP_MADE];
     } onError:^(NSError *error) {
         [SVProgressHUD dismiss];
         NSLog(@"User Cancelled Transaction");
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again later, or contact the app's customer support for assistance." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

         [alert show];
     }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self performSelector:@selector(showAdsWithDelay) withObject:nil afterDelay:1.f];
}


- (void)showAdsWithDelay {
    AdsManager *manager = [AdsManager sharedManager];
    [manager showOnSaysNoAds];
}


#endif

@end
