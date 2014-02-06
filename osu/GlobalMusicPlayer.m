//
//  GlobalMusicPlayer.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "GlobalMusicPlayer.h"
#import "Beatmap.h"
#import "SettingsDealer.h"

@implementation GlobalMusicPlayer
@synthesize playMode;
@synthesize endMode;

- (id)init
{
    self = [super init];
    if (self) {
        playMode = GlobalMusicPlayerModeFromBegin;
        endMode = GlobalMusicPlayerEndModeStop;
        SettingsDealer *settings = [[SettingsDealer alloc] init];
        loadSongsDir = settings.loadDirectory;
        saveSongsDir = settings.saveDirectory;
    }
    return self;
}
- (void)recieveFinishPlaying:(FinishPlaying )senderBlock{
    finishPlaying = senderBlock;
}
- (void)playRandomInSet:(NSSet *)beatmapSet{
    NSInteger maxBeatmapNumber = beatmapSet.count;
    NSInteger randBeatmapIndex = arc4random()%maxBeatmapNumber;
    importBeatmapSet = beatmapSet;
    
    Beatmap *beatmap = [[beatmapSet allObjects] objectAtIndex:randBeatmapIndex];
    
    mapPlaying = beatmap;
    [self playBeatmap:beatmap];
}
- (void)playBeatmap:(Beatmap *)beatmap{
    
    NSURL *mp3URL = [[loadSongsDir URLByAppendingPathComponent:beatmap.dir] URLByAppendingPathComponent:beatmap.mp3];
    //NSData *data = [[NSData alloc] initWithContentsOfURL:mp3URL];
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:&error];
    
    player.numberOfLoops = 0;
    if (self.playMode == GlobalMusicPlayerModeFromClimax) {
        float previewTime = [beatmap.previewTime intValue] * 0.001;
        player.currentTime = previewTime;
    }
    player.delegate = self;
    [player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (finishPlaying != nil) {
        finishPlaying();
    }
    
    if (      self.endMode == GlobalMusicPlayerEndModeRandom) {
        [self playRandomInSet:importBeatmapSet];
    }else if (self.endMode == GlobalMusicPlayerEndModeAgain){
        [self playBeatmap:mapPlaying];
    }else if (self.endMode == GlobalMusicPlayerEndModeStop){
        
    }
}
@end
