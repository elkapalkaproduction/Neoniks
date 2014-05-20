//
//  ContentOfBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "ContentOfBookViewController.h"
#import "UIButton+Helps.h"
#import "UIImage+Helps.h"
#import "NSURL+Helps.h"
#import "NSString+Helps.h"
#import "Utils.h"
#import "PageDetails.h"
#import "BookmarksManager.h"

@interface ContentOfBookViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chapters;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *contentOfBookTitle;
@property (strong, nonatomic) NSArray *chaptersDetails;

@end

@implementation ContentOfBookViewController

#pragma mark -
#pragma mark - ViewCycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setupView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnimation];
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)close:(id)sender {
    [Utils animationForAppear:NO fromRight:YES forView:self.contentView];
    [self performSelector:@selector(close) withObject:nil afterDelay:kAnimationHide];
}




#pragma mark -
#pragma mark - Private Methods


- (void)close {
    [self.delegate close];
}




- (void)setupView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize screenSize = CGSizeMake(CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
    changeSize(screenSize, self.view);
    [self setupText];
    self.contentOfBookTitle.image = [UIImage imageWithName:@"25_title"];
    
}


- (void)setupText {
    NSURL *chaptersUrl = [NSURL urlFromName:@"chapters" extension:@"plist"];
    NSArray *tmpChapters = [[NSArray alloc] initWithContentsOfURL:chaptersUrl];
    NSMutableArray *tmpMutableChapters = [[NSMutableArray alloc] init];

    for (int i = 0; i<tmpChapters.count; i++) {
        NSString *string = tmpChapters[i][@"name"];
        UIButton *button = (UIButton *)self.chapters[i];
        [button setTitle:string forState:UIControlStateNormal];
        [tmpMutableChapters addObject:tmpChapters[i][@"pages"]];
        [button addTarget:self action:@selector(chapterSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.chaptersDetails = [NSArray arrayWithArray:tmpMutableChapters];

#warning Fix this shit

}


- (IBAction)chapterSelected:(id)sender {
    NSInteger tag = [sender tag];
    PageDetails *pageDetails = [[PageDetails alloc] initWithPage:1 chapter:tag];
    NSInteger chapterSelected = [self numberForPageDetails:pageDetails];
    [[BookmarksManager sharedManager] setLastOpen:chapterSelected];
    [self close:nil];
    [self.delegate relaod];
}


- (void)startAnimation {
    [self.view setHidden:NO];
    [Utils animationForAppear:YES fromRight:NO forView:self.contentView];

}


- (NSInteger)numberForPageDetails:(PageDetails *)pageDetails {
    NSInteger number = pageDetails.page;
    NSInteger chapter = pageDetails.chapter - 1;
    for (int i = 0; i < chapter; i++) {
        number += [self.chaptersDetails[i] integerValue];
    }
    return number;
}


@end
