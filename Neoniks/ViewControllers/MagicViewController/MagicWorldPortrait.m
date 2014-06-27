//
//  MagicWorldPortrait.m
//  Neoniks
//
//  Created by Andrei Vidrasco on 6/27/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import "MagicWorldPortrait.h"
#import "Utils.h"

@interface MagicWorldPortrait()

@property (strong, nonatomic) IBOutlet UIImageView *characterImage;
@property (strong, nonatomic) IBOutlet UIImageView *characterName;

@end

@implementation MagicWorldPortrait

+ (instancetype)instantiate {
   NSString *nibName = NSStringFromClass([MagicWorldPortrait class]);
    
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect viewFrame = self.frame;
    CGFloat frameHeight = CGRectGetHeight(viewFrame);
    CGFloat y = (30.f / 42.f) * frameHeight;
    CGFloat width = (118.f / 210.f) * frameHeight;
    CGFloat height = (35.f / 210.f) * frameHeight;
    CGFloat x = 0.5 * (frameHeight - width);

    CGRect newRect = CGRectMake(x, y, width, height);
    self.characterName.frame = newRect;
}


- (void)setCharacterId:(NSInteger)characterId {
    _characterId = characterId;
    self.characterImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"portrait_%d", characterId]];
    self.characterName.image = [UIImage imageWithName:[NSString stringWithFormat:@"%d_name", characterId]];
    
}

- (void)addTarget:(id)target action:(SEL)action tag:(NSInteger)tag {
    self.button.tag = tag;
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
