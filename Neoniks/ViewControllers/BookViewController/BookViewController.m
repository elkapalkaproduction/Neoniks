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
@property (strong, nonatomic) NSArray *chaptersDetails;

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
#pragma mark - IBActions

- (IBAction)chapters:(id)sender {
    self.bookViewController = [[ContentOfBookViewController alloc] init];
    self.bookViewController.delegate = self;
    [self.view addSubview:self.bookViewController.view];

}


- (IBAction)bookmarkThisPage:(id)sender {
    PageDetails *currentPage = [self curentPageDetails];
    NSInteger pageNumber = [self numberForPageDetails:currentPage];
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
    NSInteger curentPageNumber = [self numberForPageDetails:curentPage];
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
    
    [self.popoverControler presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - 
#pragma mark - Private methods 

- (UIViewController *)loadNext:(NSInteger)isNext viewController:(UIViewController *)vc{
    ContentBookViewController *currentBook = (ContentBookViewController *)vc;
    PageDetails *currentPage = currentBook.currentPage;
    PageDetails *prevCoord = [self loadPreviousPage:currentPage isPrevious:isNext];
    if (prevCoord.page == 0) {
        return nil;
    }
    ContentBookViewController *prevBook = [[ContentBookViewController alloc] initWithPage:prevCoord];
    return prevBook;
    
}


- (NSInteger)numberOfPages {
    NSInteger number = 0;
    for (NSNumber *object in self.chaptersDetails) {
        number += [object integerValue];
    }
    return number;
}


- (PageDetails *)pageDetailsForNumber:(NSInteger)number {
    NSInteger chapter = 0;
    NSInteger page = number;
    while ([self.chaptersDetails[chapter] integerValue] < page) {
        page -= [self.chaptersDetails[chapter] integerValue];
        chapter++;
    }
    PageDetails *pageDetail = [[PageDetails alloc] initWithPage:page chapter:chapter + 1];
    
    return pageDetail;
}


- (NSInteger)numberForPageDetails:(PageDetails *)pageDetails {
    NSInteger number = pageDetails.page;
    NSInteger chapter = pageDetails.chapter - 1;
    for (int i = 0; i < chapter; i++) {
        number += [self.chaptersDetails[i] integerValue];
    }
    return number;
}


- (PageDetails *)loadPreviousPage:(PageDetails *)pageDetail isPrevious:(NSInteger)prev{
    NSInteger pagePrevious = pageDetail.page + prev;
    NSInteger chapterPrevious = pageDetail.chapter;
    
    if (pagePrevious > [self.chaptersDetails[chapterPrevious - 1] integerValue]) {
        chapterPrevious++;
        if (chapterPrevious - 1 < [self.chaptersDetails count]) {
            pagePrevious = 1;
        } else {
            pagePrevious = 0;
            chapterPrevious = 0;
        }
    } else if (pagePrevious < 1){
        chapterPrevious--;
        if (chapterPrevious > 0) {
            pagePrevious = [self.chaptersDetails[chapterPrevious - 1] integerValue];
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
    NSURL *chaptersUrl = [NSURL urlFromName:@"chapters" extension:@"plist"];
    NSArray *tmpChapters = [[NSArray alloc] initWithContentsOfURL:chaptersUrl];
    NSMutableArray *tmpMutableChapters = [[NSMutableArray alloc] init];
    for (int i = 0; i < tmpChapters.count; i++) {
        [tmpMutableChapters addObject:tmpChapters[i][@"pages"]];
    }
#warning Fix this shit
    self.chaptersDetails = [NSArray arrayWithArray:tmpMutableChapters];
    NSInteger maximumPage = [self numberOfPages];
    self.sliderPreview.maximumValue = maximumPage;
    self.maxPageLabel.text = [NSString stringWithFormat:@"%d",maximumPage];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrShowSupportView)];
    [self.view addGestureRecognizer:tapGesture];

}


- (void)setupPageViewController {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.delegate = self;
    NSInteger lastOpenPage = [[BookmarksManager sharedManager] lastOpen];
    PageDetails *page = [self pageDetailsForNumber:lastOpenPage];
    
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
    NSInteger pageNumber = [self numberForPageDetails:currentPage];

    if ([[BookmarksManager sharedManager] bookmarkIsSaved:pageNumber]) {
        [self.bookmarkPageButton setTitle:@"Unbookmark this page" forState:UIControlStateNormal];
    } else {
        [self.bookmarkPageButton setTitle:@"Bookmark this page" forState:UIControlStateNormal];
    }

}


- (void)isChangedPage {
    PageDetails *curentPage = [self curentPageDetails];;
    NSInteger page = [self numberForPageDetails:curentPage];
    self.currentPageLabel.text = [NSString stringWithFormat:@"%d",page];
    self.sliderPreview.value = page;
    
    
}


- (void)showPage:(NSInteger)page {
    ContentBookViewController *contentBook = self.pageViewController.viewControllers[0];
    self.sliderPreview.value = page;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%d", page];
    contentBook.currentPage = [self pageDetailsForNumber:page];
    [self updateBookmarkInfo];

}


@end
