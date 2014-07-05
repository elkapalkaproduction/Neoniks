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

const CGFloat ribbonAnimationDuration = 1.f;
const NSInteger requiredNumberOfShowRibbonAnimated = 4;

NSString *const numberOfRibbonShowed = @"numberOfRibbonShowed";
const CGFloat ribbonDefaultHiddeY = 70;

@interface BookViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, AllBookmarksDelegate, ContentOfBookDelegate, contentBookProtocol>
@property (strong, nonatomic) IBOutlet UIButton *tableOfContentsButton;
@property (strong, nonatomic) IBOutlet UIButton *allBookmarkButton;
@property (strong, nonatomic) IBOutlet UIButton *bookmarkPageButton;
@property (strong, nonatomic) IBOutlet UIButton *exitButton;
@property (strong, nonatomic) IBOutlet UISlider *sliderPreview;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *ribbonView;

@property (strong, nonatomic) ContentOfBookViewController *bookViewController;
@property (strong, nonatomic) UIPopoverController *popoverControler;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) ChaptersCollection *collection;

@property (assign, nonatomic) BOOL isShowedOnScreenSupportView;
@property (assign, nonatomic) CGFloat firstY;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSupportView];
    [self setupPageViewController];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self ribbonViewAppearing];
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


- (void)hideOrShowSupportView {
    self.isShowedOnScreenSupportView = !self.isShowedOnScreenSupportView;
    self.bottomView.hidden = self.ribbonView.hidden = self.isShowedOnScreenSupportView;
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
    self.popoverControler.popoverContentSize = bookmarkView.view.frame.size;
    UIButton *button = sender;
    UIView *superView = button.superview;
    [self.popoverControler presentPopoverFromRect:superView.frame
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}


- (IBAction)dragRibbonDown:(UIPanGestureRecognizer *)sender {
    if (self.ribbonView.hidden) return;
    CGFloat translatedYPoint = [sender translationInView:self.view].y;
    UIView *ribbon = [sender view];
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan:
            self.firstY = ribbon.center.y;
            break;
        case UIGestureRecognizerStateEnded:{
            CGFloat velocityY = (0.2 * [sender velocityInView:self.view].y);
            CGFloat finalY = translatedYPoint + velocityY;
            finalY = finalY < 0 ? ribbonDefaultHiddeY - CGRectGetHeight(ribbon.frame) : 0;
            if (finalY == 0.f) {
                [[NSUserDefaults standardUserDefaults] setInteger:requiredNumberOfShowRibbonAnimated forKey:numberOfRibbonShowed];
            }
            [UIView animateWithDuration:0.4 animations:^{
                setYFor(finalY, ribbon);
            }];
            break;
        }
        default:
            break;
    }
}


#pragma mark -
#pragma mark - Private methods 

- (CGRect)popoverSize {
    CGPoint origin = CGPointZero;
    CGSize size = CGSizeZero;
    if (isIphone()) {
        size = CGSizeMake(320, 400);
    } else {
        size = CGSizeMake(320, 400);
    }
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}


- (void)ribbonViewAppearing {
    self.ribbonView.hidden = NO;
    CGFloat ribbonHeight = CGRectGetHeight(self.ribbonView.frame);
    CGFloat finalY = ribbonDefaultHiddeY - ribbonHeight;
    CGFloat reverseDuration = (1 - (ribbonDefaultHiddeY / ribbonHeight)) * ribbonAnimationDuration;
    NSInteger numberOfShows = [[NSUserDefaults standardUserDefaults] integerForKey:numberOfRibbonShowed];
    if (numberOfShows == requiredNumberOfShowRibbonAnimated) {
        CGFloat duration = (ribbonDefaultHiddeY / ribbonHeight) * ribbonAnimationDuration;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            setYFor(finalY, self.ribbonView);
        } completion:^(BOOL finished) {
            setYFor(finalY, self.ribbonView);
        }];
        return;
    }
    numberOfShows++;
    [[NSUserDefaults standardUserDefaults] setInteger:numberOfShows forKey:numberOfRibbonShowed];
    
    [UIView animateWithDuration:ribbonAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        setYFor(0, self.ribbonView);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:reverseDuration delay:ribbonAnimationDuration / 3 options:UIViewAnimationOptionCurveLinear animations:^{
            setYFor(finalY, self.ribbonView);
        } completion:^(BOOL finished) {
            setYFor(finalY, self.ribbonView);
        }];
    }];
}


- (UIViewController *)loadNext:(NSInteger)isNext viewController:(UIViewController *)vc {
    ContentBookViewController *currentBook = (ContentBookViewController *)vc;
    PageDetails *currentPage = currentBook.currentPage;
    PageDetails *prevCoord = [self loadPreviousPage:currentPage isPrevious:isNext];
    if (prevCoord.page == 0) {
        return nil;
    }
    ContentBookViewController *prevBook = [[ContentBookViewController alloc] initWithPage:prevCoord];
    prevBook.delegate = self;
    
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
}


- (void)setupPageViewController {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;
    NSInteger lastOpenPage = [[BookmarksManager sharedManager] lastOpen];
    PageDetails *page = [self.collection pageDetailsForNumber:lastOpenPage];
    
    ContentBookViewController *firsPge = [[ContentBookViewController alloc] initWithPage:page];
    firsPge.delegate = self;
    [self.pageViewController.view setFrame:self.view.frame];
    [self.pageViewController setViewControllers:@[firsPge]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    self.pageViewController.dataSource = self;
    
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self isChangedPage];
    [self updateLanguage];

}


- (void)updateBookmarkInfo {
    PageDetails *currentPage = [self curentPageDetails];
    NSInteger pageNumber = [self.collection numberForPageDetails:currentPage];

    if ([[BookmarksManager sharedManager] bookmarkIsSaved:pageNumber]) {
        [self.bookmarkPageButton setImage:[UIImage imageWithName:@"delete_a_bookmark"]];
    } else {
        [self.bookmarkPageButton setImage:[UIImage imageWithName:@"bookmark"]];
    }

}


- (void)isChangedPage {
    PageDetails *curentPage = [self curentPageDetails];;
    NSInteger page = [self.collection numberForPageDetails:curentPage];
    self.sliderPreview.value = page;
    
    
}


- (void)showPage:(NSInteger)page {
    ContentBookViewController *contentBook = self.pageViewController.viewControllers[0];
    self.sliderPreview.value = page;
    contentBook.currentPage = [self.collection pageDetailsForNumber:page];
    [self updateBookmarkInfo];
}


- (void)updateLanguage {
    [self updateBookmarkInfo];

    [self.tableOfContentsButton setImage:[UIImage imageWithName:@"table_of_content"]];
    [self.allBookmarkButton setImage:[UIImage imageWithName:@"all_bookmarks"]];
    [self.exitButton setImage:[UIImage imageWithName:@"exit"]];


}

@end
