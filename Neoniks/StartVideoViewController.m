//
//  StartVideoViewController.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 11/7/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "StartVideoViewController.h"
#import "Utils.h"

@import MediaPlayer;

@interface StartVideoViewController ()
@property (strong, nonatomic) MPMoviePlayerController *logoPlayer;

@end

@implementation StartVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playLogoVideo];
    // Do any additional setup after loading the view.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[AudioPlayer sharedPlayer] play];
}


- (void)playLogoVideo {
    NSURL *url = [NSURL URLWithString:@"https://www.dropbox.com/sm/playlist/0smioq97vbrcx50/Neoniks.eng.mp4?secure_hash="];
    if (isRussian()) {
        url = [NSURL URLWithString:@"https://www.dropbox.com/sm/playlist/c3fsbhbl0nrwabz/Neoniks.rus.mp4?secure_hash="];
    }
    self.logoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.logoPlayer.shouldAutoplay = NO;
    self.logoPlayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.logoPlayer.fullscreen = YES;
    self.logoPlayer.view.frame = (CGRect) {CGPointZero, [Utils screenSize]};
    self.logoPlayer.controlStyle = MPMovieControlStyleNone;
    self.logoPlayer.view.userInteractionEnabled = NO;
    [self.view addSubview:self.logoPlayer.view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinishedNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.logoPlayer];
    [self.logoPlayer play];
}


- (void)playbackFinishedNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self.logoPlayer.view removeFromSuperview];
    self.logoPlayer = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
