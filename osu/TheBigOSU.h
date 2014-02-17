//
//  TheBigOSU.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-14.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SKSceneWithAdditions;
@class TheBigOSUButton;
@class TheBigOSUShadow;
@class TheBigOSUShockwave;
@class TheBigOSUMenuButtons;

@class GlobalMusicPlayer;
@class Beatmap;
@interface TheBigOSU : SKNode{
    int menuLevel;
    
    SKSceneWithAdditions *callerScene;
    GlobalMusicPlayer *GMP;
    
    TheBigOSUButton *button;
    SKAction        *pop;
    TheBigOSUShadow *shadow;
    TheBigOSUShockwave   *shockwave;
    TheBigOSUMenuButtons *menuButtons;
}

@property (readwrite) float popingSpeed;
- (void)resizeTo:(NSRect)frame;
- (void)synchronizePopingTo:(Beatmap *)beatmap;
- (id)initWithScene:(SKSceneWithAdditions *)scene;
@property NSRect frame;

@end
