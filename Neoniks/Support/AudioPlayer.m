//
//  AudioPlayer.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "AudioPlayer.h"

@interface AudioPlayer ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation AudioPlayer

+ (instancetype)sharedPlayer {
    static AudioPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      sharedMyManager = [[self alloc] init];
                  });

    return sharedMyManager;
}


- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Magical" withExtension:@"mp3"];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        _audioPlayer.numberOfLoops = -1;
    }

    return _audioPlayer;
}


- (void)play {
    [self.audioPlayer play];
}


- (void)pause {
    [self.audioPlayer pause];
}

@end
