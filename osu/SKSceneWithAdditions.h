//
//  SKSceneWithAdditions.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GlobalMusicPlayer.h"
#import "ApplicationSupport.h"

@class Beatmap;
@class GlobalMusicPlayer;

static const uint32_t cursorCategory    =  0x1 << 0;
static const uint32_t buttonCategory    =  0x1 << 1;
static const uint32_t hitObjectCategory =  0x1 << 2;

@protocol SKNodeMouseOverEvents <NSObject>
@optional
- (void)didMouseEnter;
- (void)didMouseExit;
@end
@interface SKSceneWithAdditions : SKScene <GMPEventDelegate, GMPModeDelegate, AppSupportReportEventDelegate, SKPhysicsContactDelegate>{
    NSMutableSet *contactSet;
}

@property (nonatomic ) CGPoint lastFrameCursorPosition;
@property (nonatomic , retain) SKNode *cursor;
@property (nonatomic , retain) SKTexture *cursortailTexture;
- (void)addContact:(SKNode *)node;

@property (readonly) float leftMargin;
@property (readonly) float rightMargin;
@property (readonly) float topMargin;
@property (readonly) float bottomMargin;

@property (readonly, nonatomic) GlobalMusicPlayer *GMP;
/**
 Don't forget to call super when overide.
 不要忘记在覆写前运行super.
 */
- (void)displayMessage:(NSString *)messageString;
- (void)displayWarning:(NSString *)messageString;
- (void)presentBackScene;
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
