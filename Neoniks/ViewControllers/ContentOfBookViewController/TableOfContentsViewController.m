//
//  ContentOfBookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/12/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "TableOfContentsViewController.h"
#import "UIButton+Helps.h"
#import "UIImage+Helps.h"
#import "NSURL+Helps.h"
#import "NSString+Helps.h"
#import "Utils.h"
#import "PageDetails.h"
#import "BookmarksManager.h"
#import "ChaptersCollection.h"
#import "MKStoreManager.h"

@interface TableOfContentsViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chapters;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *contentOfBookTitle;
@property (strong, nonatomic) ChaptersCollection *collection;

@end

@implementation TableOfContentsViewController

#pragma mark -
#pragma mark - ViewCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
}


#pragma mark -
#pragma mark - Custom Accesors

- (ChaptersCollection *)collection {
    if (!_collection) {
        _collection = [[ChaptersCollection alloc] init];
    }

    return _collection;
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)close:(id)sender {
    [self.delegate closeTableOfContents];
}


#pragma mark -
#pragma mark - Private Methods

- (void)setupView {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGSize screenSize = CGSizeMake(CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
    changeSize(screenSize, self.view);
    [self setupText];
    self.contentOfBookTitle.image = [UIImage imageWithName:@"25_title"];
}


- (void)setupText {
    for (int i = 0; i < [self.collection numberOfChapters]; i++) {
        NSString *string = [self.collection chapterNumber:i].chapterName;
        UIButton *button = (UIButton *)self.chapters[i];
        [button setTitle:string forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chapterSelected:) forControlEvents:UIControlEventTouchUpInside];
#ifdef NeoniksFree
        if ([MKStoreManager isFeaturePurchased:SUB_PRODUCT_ID]) {
            continue;
        }
        if (i < numberOfFreeChapters) {
            NSString *finalString = [string stringByAppendingString:[NSString thisIsFreeLocalized]];
            NSMutableAttributedString *atributtedString = [[NSMutableAttributedString alloc] initWithString:finalString];
            [atributtedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor colorWithRed:41.f / 255.f green:10.f / 255.f blue:0 alpha:1.f]
                                     range:[finalString rangeOfString:string]];
            [atributtedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor colorWithRed:34.f / 255.f green:132.f / 255.f blue:23.f / 255.f alpha:1.f]
                         range:[finalString rangeOfString:[NSString thisIsFreeLocalized]]];
            [button setAttributedTitle:atributtedString forState:UIControlStateNormal];
        }
#endif
    }
}


- (IBAction)chapterSelected:(id)sender {
    NSInteger tag = [sender tag];
    PageDetails *pageDetails = [[PageDetails alloc] initWithPage:1 chapter:tag];
    NSInteger chapterSelected = [self.collection numberForPageDetails:pageDetails];
    [[BookmarksManager sharedManager] setLastOpen:chapterSelected];
    [self close:nil];
    [self.delegate relaod];
}

@end
