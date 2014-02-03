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

@implementation SingleSongSelectScene
- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        loadSongsDirectory = [[[[SettingsDealer alloc] init] getLoadDirectory] URLByAppendingPathComponent:@"Songs"];

    }
    return self;
}
- (void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
    if (view == self.view) {
        if (![self isBeatmapListUpToDate]) {
            ScaningScene *scaningScene = [ScaningScene sceneWithSize:view.frame.size];
            [self.view presentScene:scaningScene];
            [scaningScene loadAllBeatmaps];
        }
    }
}
- (BOOL)isBeatmapListUpToDate{
    return NO;
}

@end
