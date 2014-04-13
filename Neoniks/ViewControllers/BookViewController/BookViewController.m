//
//  BookViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 4/13/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "BookViewController.h"
#import "ContentBookViewController.h"

@interface BookViewController () <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIButton *closeBookButton;
@property (strong, nonatomic) NSArray *array;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ContentBookViewController *contentBook1 = [[ContentBookViewController alloc] initWithPageNumber:1];
    ContentBookViewController *contentBook2 = [[ContentBookViewController alloc] initWithPageNumber:2];
    ContentBookViewController *contentBook3 = [[ContentBookViewController alloc] initWithPageNumber:3];
    ContentBookViewController *contentBook4 = [[ContentBookViewController alloc] initWithPageNumber:4];
    ContentBookViewController *contentBook5 = [[ContentBookViewController alloc] initWithPageNumber:5];
    ContentBookViewController *contentBook6 = [[ContentBookViewController alloc] initWithPageNumber:6];
    _array = @[contentBook1, contentBook2, contentBook3, contentBook4, contentBook5, contentBook6];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    [self.pageViewController.view setFrame:self.view.frame];
    [self.pageViewController setViewControllers:@[contentBook1]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil]; 
    self.pageViewController.dataSource = self;
    [self.view addSubview:self.pageViewController.view];
    [self.view bringSubviewToFront:_closeBookButton];

}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger i = [_array indexOfObject:viewController];
    if (i > 0) i = i - 1; else return nil;
    return _array[i];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger i = [_array indexOfObject:viewController];
    if (i < ([_array count])-1) i = i + 1; else return nil;
    return _array[i];
}
- (IBAction)closeBookAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)loadNextPage:(id)sender {
    
    NSLog(@"To right");
}


- (IBAction)loadPreviousPage:(id)sender {
    NSLog(@"To left");
}

@end
