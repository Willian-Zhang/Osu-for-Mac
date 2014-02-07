//
//  SingleSongSelectScene.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-1.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SingleSongSelectScene.h"
#import "SettingsDealer.h"
#import "ScaningScene.h"
#import "AppDelegate.h"
#import "ApplicationSupport.h"
#import "GlobalMusicPlayer.h"
#import "Beatmap.h"

@implementation SingleSongSelectScene
- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor blackColor];
        loadSongsDirectory = [[[SettingsDealer alloc] init] loadDirectory];
    }
    return self;
}
- (void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
    if (view == self.view) {
        if (![self loadDatabaseIfExist]) {
            ScaningScene *scaningScene = [ScaningScene sceneWithSize:view.frame.size];
            [self.view presentScene:scaningScene];
            [scaningScene loadAllBeatmaps:^(void){
                //osuDB = [ApplicationSupport getDatabase];
                [self.view presentScene:self transition:[SKTransition crossFadeWithDuration:0.5]];
                [self initiate];
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
- (BOOL)loadDatabaseIfExist{
    if (osuDB == nil) {
        ApplicationSupport *appSupport = [(AppDelegate *)[[NSApplication sharedApplication] delegate] appSupport];
        if (![appSupport isDatabaseExist]) {
            return NO;
        }
        //Adds
    }
    return YES;
}
- (void)initiate{

    
}

- (NSDictionary *)beatmapDicAtIndex:(NSInteger)index{
    return [(NSArray *)[osuDB objectForKey:@"beatmapArray"] objectAtIndex:index];
}

@end
