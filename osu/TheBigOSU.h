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
@class TheBigOSUMenuLevel1;
@class TheBigOSUMenuLevel2;

@class GlobalMusicPlayer;
@class Beatmap;
@interface TheBigOSU : SKNode{
    int menuLevel;
    
    //SKSceneWithAdditions *callerScene;
    GlobalMusicPlayer *GMP;
    
    TheBigOSUButton *button;
    SKAction        *pop;
    TheBigOSUShadow *shadow;
    TheBigOSUShockwave   *shockwave;
    TheBigOSUMenuLevel1 *menuLevel1;
    TheBigOSUMenuLevel2 *menuLevel2;
}

@property (readwrite) float popingSpeed;
@property (weak,readonly) SKSceneWithAdditions *callerScene;
- (void)resizeTo:(NSRect)frame;
- (void)synchronizePopingTo:(Beatmap *)beatmap;
- (id)initWithScene:(SKSceneWithAdditions *)scene;
- (void)presentLevel:(int)level;
- (void)presentSoloScene;
@property NSRect frame;

@end
