//
//  SKSceneWithAdditions.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Beatmap;
@class GlobalMusicPlayer;

@interface SKSceneWithAdditions : SKScene

@property (nonatomic ) CGPoint lastFrameCursorPosition;
@property (nonatomic , retain) SKNode *cursor;
@property (nonatomic , retain) SKTexture *cursortailTexture;

@property (readonly) float leftMargin;
@property (readonly) float rightMargin;
@property (readonly) float topMargin;
@property (readonly) float bottomMargin;

@property (readonly, nonatomic) GlobalMusicPlayer *musicPlayer;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)displayMessage:(NSString *)messageString;
- (void)displayWarning:(NSString *)messageString;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)leftDown:(NSEvent *)theEvent;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)leftUp:(NSEvent *)theEvent;
- (CGPoint)locationInScene;




- (void)didMusicMeetTimingPoint:(Beatmap *)beatmap;
- (void)didMusicMeetKeyTimingPoint:(Beatmap *)beatmap;
/**
 Override this to perform Global Music Player Event, called when one music ends play.
 覆写此以提供提供Global Music Player事件, 将在一首歌曲播放完成后执行.
 */
- (void)willMusicEndPlaying:(Beatmap *)beatmap;
/**
 Override this to perform Global Music Player Event, called when one music ends play also the player is really to play next.
 覆写此以提供提供Global Music Player事件, 将在一首歌曲播放完成后,且播放器准备播放下一首时执行.
 */
- (void)didMusicEndPlaying:(Beatmap *)beatmap;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)didChangeSize:(CGSize)oldSize;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)keyDown:(NSEvent *)theEvent;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)keyUp:(NSEvent *)theEvent;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)mouseDown:(NSEvent *)theEvent;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)mouseUp:(NSEvent *)theEvent;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)didSimulatePhysics;
@end
