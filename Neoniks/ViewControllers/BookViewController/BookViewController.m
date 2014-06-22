//
//  BookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "BookViewController.h"
#import "ContentBookViewController.h"
#import "AudioPlayer.h"
#import "PageDetails.h"
#import "NSURL+Helps.h"
#import "UIPopoverController+iPhone.h"
#import "BookmarksManager.h"
#import "AllBookmarsViewController.h"
#import "ContentOfBookViewController.h"
#import "ChaptersCollection.h"

@interface BookViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, AllBookmarksDelegate, ContentOfBookDelegate>
@property (strong, nonatomic) IBOutlet UIButton *bookmarkPageButton;
@property (strong, nonatomic) IBOutlet UILabel *maxPageLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentPageLabel;
@property (strong, nonatomic) IBOutlet UISlider *sliderPreview;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) ContentOfBookViewController *bookViewController;
@property (strong, nonatomic) UIPopoverController *popoverControler;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) ChaptersCollection *collection;

@property (assign, nonatomic) BOOL isShowedOnScreenSupportView;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSupportView];
    [self setupPageViewController];
    
}


#pragma mark -
#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self loadNext:-1 viewController:viewController];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    return [self loadNext:1 viewController:viewController];
}


- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    [self isChangedPage];
    [self updateBookmarkInfo];
    
}


- (void)close {
    [self.bookViewController.view removeFromSuperview];
    self.bookViewController = nil;

}


- (void)relaod {
    [self bookmarksRequiredToShow:[[BookmarksManager sharedManager] lastOpen]];
}


#pragma mark - 
#pragma mark - Accesors

- (ChaptersCollection *)collection {
    if (!_collection) {
        _collection = [[ChaptersCollection alloc] init];
    }
    
    return _collection;
}


- (ContentOfBookViewController *)bookViewController {
    if (!_bookViewController) {
        _bookViewController = [[ContentOfBookViewController alloc] init];
    }
    
    return _bookViewController;
}


#pragma mark -
#pragma mark - IBActions

- (IBAction)chapters:(id)sender {
    self.bookViewController.delegate = self;
    [self.view addSubview:self.bookViewController.view];

}


- (IBAction)bookmarkThisPage:(id)sender {
    PageDetails *currentPage = [self curentPageDetails];
    NSInteger pageNumber = [self.collection numberForPageDetails:currentPage];
    [[BookmarksManager sharedManager] addOrRemoveBookmarkForPage:pageNumber];
    [self updateBookmarkInfo];
}


- (IBAction)hideOrShowSupportView {
    self.isShowedOnScreenSupportView = !self.isShowedOnScreenSupportView;
    self.bottomView.hidden = self.topView.hidden = self.isShowedOnScreenSupportView;
}


- (IBAction)closeBookAction:(id)sender {
    [[AudioPlayer sharedPlayer] play];
    PageDetails *curentPage = [self curentPageDetails];
    NSInteger curentPageNumber = [self.collection numberForPageDetails:curentPage];
    [[BookmarksManager sharedManager] setLastOpen:curentPageNumber];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)sliderChangeValue:(UISlider *)sender {
    NSInteger sliderValue = sender.value;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
    [self showPage:sliderValue];

    
}


- (void)bookmarksRequiredToShow:(NSInteger)page {
    [self showPage:page];
    [self.popoverControler dismissPopoverAnimated:YES];
}


- (IBAction)allBookmarks:(UIButton *)sender {
    NSString *nibName = NSStringFromClass([AllBookmarsViewController class]);
    AllBookmarsViewController *bookmarkView = [[AllBookmarsViewController alloc] initWithNibName:nibName bundle:nil];
    bookmarkView.delegate = self;
    self.popoverControler = [[UIPopoverController alloc] initWithContentViewController:bookmarkView];
    UIButton *button = sender;
    UIView *superView = button.superview;
    [self.popoverControler presentPopoverFromRect:superView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


#pragma mark - 
#pragma mark - Private methods 

- (UIViewController *)loadNext:(NSInteger)isNext viewController:(UIViewController *)vc {
    ContentBookViewController *currentBook = (ContentBookViewController *)vc;
    PageDetails *currentPage = currentBook.currentPage;
    PageDetails *prevCoord = [self loadPreviousPage:currentPage isPrevious:isNext];
    if (prevCoord.page == 0) {
        return nil;
    }
    ContentBookViewController *prevBook = [[ContentBookViewController alloc] initWithPage:prevCoord];
    
    return prevBook;
}


- (PageDetails *)loadPreviousPage:(PageDetails *)pageDetail isPrevious:(NSInteger)prev {
    NSInteger pagePrevious = pageDetail.page + prev;
    NSInteger chapterPrevious = pageDetail.chapter;
    
    if (pagePrevious > [self.collection chapterNumber:chapterPrevious - 1].numberOfPages) {
        chapterPrevious++;
        if (chapterPrevious - 1 < [self.collection numberOfChapters]) {
            pagePrevious = 1;
        } else {
            pagePrevious = 0;
            chapterPrevious = 0;
        }
    } else if (pagePrevious < 1){
        chapterPrevious--;
        if (chapterPrevious > 0) {
            pagePrevious = [self.collection chapterNumber:chapterPrevious - 1].numberOfPages;
        } else {
            chapterPrevious = 0;
            pagePrevious = 0;
        }
    }
    PageDetails *page = [[PageDetails alloc] initWithPage:pagePrevious chapter:chapterPrevious];
    
    return page;
}


- (PageDetails *)curentPageDetails {
    ContentBookViewController *contentBook = self.pageViewController.viewControllers[0];
    
    return contentBook.currentPage;
}


- (void)setupSupportView {
    self.isShowedOnScreenSupportView = NO;
    NSInteger maximumPage = [self.collection numberOfPages];
    self.sliderPreview.maximumValue = maximumPage;
    self.maxPageLabel.text = [NSString stringWithFormat:@"%d", maximumPage];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrShowSupportView)];
    [self.view addGestureRecognizer:tapGesture];

}


- (void)setupPageViewController {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;
    NSInteger lastOpenPage = [[BookmarksManager sharedManager] lastOpen];
    PageDetails *page = [self.collection pageDetailsForNumber:lastOpenPage];
    
    ContentBookViewController *firsPge = [[ContentBookViewController alloc] initWithPage:page];
    [self.pageViewController.view setFrame:self.view.frame];
    [self.pageViewController setViewControllers:@[firsPge]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    self.pageViewController.dataSource = self;
    
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self isChangedPage];

}


- (void)updateBookmarkInfo {
    PageDetails *currentPage = [self curentPageDetails];
    NSInteger pageNumber = [self.collection numberForPageDetails:currentPage];

    if ([[BookmarksManager sharedManager] bookmarkIsSaved:pageNumber]) {
        [self.bookmarkPageButton setTitle:@"Unbookmark this page" forState:UIControlStateNormal];
    } else {
        [self.bookmarkPageButton setTitle:@"Bookmark this page" forState:UIControlStateNormal];
    }

}


- (void)isChangedPage {
    PageDetails *curentPage = [self curentPageDetails];;
    NSInteger page = [self.collection numberForPageDetails:curentPage];
    self.currentPageLabel.text = [NSString stringWithFormat:@"%d", page];
    self.sliderPreview.value = page;
    
    
}


- (void)showPage:(NSInteger)page {
    ContentBookViewController *contentBook = self.pageViewController.viewControllers[0];
    self.sliderPreview.value = page;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%d", page];
    contentBook.currentPage = [self.collection pageDetailsForNumber:page];
    [self updateBookmarkInfo];
}

@end
