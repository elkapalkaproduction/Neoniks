//
//  AudioPlayer.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject

+ (instancetype)sharedPlayer;
- (void)play;
- (void)pause;
- (BOOL)isPlaying;

@end
