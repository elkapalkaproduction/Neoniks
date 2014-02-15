//
//  ViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 2/11/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "LogoViewController.h"
#import "MainViewController.h"
@interface LogoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation LogoViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_logoImageView setImage:[Utils imageWithName:@"logo"]];
}
- (void)viewDidLoad
{
    float timeInterval = 1.f;
    [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logoImageView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:timeInterval delay:timeInterval options:UIViewAnimationOptionCurveEaseIn animations:^{
            _logoImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(goToMainViewControllerWithDelay) withObject:nil afterDelay:timeInterval];
        }];
    }];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)goToMainViewControllerWithDelay{
    MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [[self navigationController] pushViewController:viewController animated:NO];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
