//
//  SingleSongSelectScene.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-1.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SingleSongSelectScene.h"

#import "AppDelegate.h"
#import "SettingsDealer.h"
#import "ApplicationSupport.h"
#import "GlobalMusicPlayer.h"

#import "MainScene.h"
#import "ScaningScene.h"

#import "SKBackNode.h"

@implementation SingleSongSelectScene
- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor blackColor];
        appSupport = [(AppDelegate *)[[NSApplication sharedApplication] delegate] appSupport];
        [self addChild:[[SKBackNode alloc] initWithScene:self]];
    }
    return self;
}
- (void)willMoveFromView:(SKView *)view{
    
}
- (void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
    if (view == self.view) {
        if (![appSupport isAllBeatmapsReady]) {
            ScaningScene *scaningScene = [ScaningScene sceneWithSize:view.frame.size];
            [self.view presentScene:scaningScene];
            [scaningScene makeAllBeatmapsReady:^(BOOL result){
                if (result == YES) {
                    [self.view presentScene:self transition:[SKTransition fadeWithColor:[NSColor blackColor] duration:0.5]];
                    [self initiate];
                }else{
                    
                }
            }];
        }else{
            [self initiate];
        }
    }
}
- (void)initBackgroundImage{
    //super.musicPlayer.mapPlaying.dbSource
}
- (void)loadBackgroundImage{
    
}
- (void)initiate{

    
}
#pragma mark fangfa
- (void)presentBackScene{
    MainScene *mainScene = [MainScene sceneWithSize:self.frame.size];
    [self.view presentScene:mainScene transition:[SKTransition fadeWithColor:[NSColor blackColor] duration:0.5]];
}
@end
