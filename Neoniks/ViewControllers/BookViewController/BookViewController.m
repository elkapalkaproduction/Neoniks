//
//  BookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "BookViewController.h"
#import "ContentBookViewController.h"
#import "AppDelegate.h"
@interface BookViewController () <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIButton *closeBookButton;
@property (strong, nonatomic) NSArray *chaptersDetails;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *chaptersUrl = [Utils urlFromName:@"chapters" extension:@"plist"];
    self.chaptersDetails = [[NSArray alloc] initWithContentsOfURL:chaptersUrl];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    ContentBookViewController *firsPge = [[ContentBookViewController alloc] initWithPageNumber:1 chapter:1];
    [self.pageViewController.view setFrame:self.view.frame];
    [self.pageViewController setViewControllers:@[firsPge]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    self.pageViewController.dataSource = self;
    [self.view addSubview:self.pageViewController.view];
    [self.view bringSubviewToFront:_closeBookButton];
    
}
- (NSDictionary *)loadPreviousPage:(NSInteger)pageNumber andChapter:(NSInteger)chapterNumber isPrevious:(NSInteger)prev{
    NSInteger pagePrevious = pageNumber + prev;
    NSInteger chapterPrevious = chapterNumber;
    
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

    return @{@"previousPage": [NSNumber numberWithInteger:pagePrevious],
             @"previousChapter": [NSNumber numberWithInteger:chapterPrevious]};
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self loadNext:-1 viewController:viewController];
}
- (UIViewController *)loadNext:(NSInteger)isNext viewController:(UIViewController *)vc{
    ContentBookViewController *currentBook = (ContentBookViewController *)vc;
    NSInteger currentPage = currentBook.page;
    NSInteger currentChapter = currentBook.chapter;
    NSDictionary *prevCoord = [self loadPreviousPage:currentPage andChapter:currentChapter isPrevious:isNext];
    NSInteger toShowPage = [prevCoord[@"previousPage"] integerValue];
    NSInteger toShowChapter = [prevCoord[@"previousChapter"] integerValue];
    if (toShowPage == 0) {
        return nil;
    }
    return [[ContentBookViewController alloc] initWithPageNumber:toShowPage chapter:toShowChapter];

}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self loadNext:1 viewController:viewController];
}
- (IBAction)closeBookAction:(id)sender {
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] audioPlayer] play];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
