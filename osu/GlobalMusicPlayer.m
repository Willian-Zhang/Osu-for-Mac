//
//  GlobalMusicPlayer.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "GlobalMusicPlayer.h"
#import "Beatmap.h"
#import "TimingPoint.h"
#import "SettingsDealer.h"
#include <math.h>

@implementation GlobalMusicPlayer
@synthesize playMode;
@synthesize endMode;

@synthesize mapPlaying;

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
- (void)recieveWillEndPlaying:(GlobalMusicPlayerWillEndPlaying)willEndPlaying
                DidEndPlaying:(GlobalMusicPlayerDidEndPlaying)didEndPlaying
{
    DoWillEndPlaying = willEndPlaying;
    DoDidEndPlaying  = didEndPlaying;
}
- (void)recieveMeetTimingPoint:(GlobalMusicPlayerDidMeetTimingPoint)timingPointBlock
                      KeyPoint:(GlobalMusicPlayerDidMeetKeyTimingPoint)keyTimingPintBlock
{
    DoMeetTimingPoint = timingPointBlock;
    DoMeetKeyTimingPoint = keyTimingPintBlock;
}

- (void)playRandomInSet:(NSSet *)beatmapSet{
    NSInteger maxBeatmapNumber = beatmapSet.count;
    NSInteger randBeatmapIndex = arc4random()%maxBeatmapNumber;
    importBeatmapSet = beatmapSet;
    Beatmap *beatmap = [[beatmapSet allObjects] objectAtIndex:randBeatmapIndex];
    [self playBeatmap:beatmap];
}
- (void)playBeatmap:(Beatmap *)beatmap{
    mapPlaying = beatmap;
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
    [player prepareToPlay];
    
    /*Timers
     */
    int timingPointNum = (int)[beatmap.timingPointsSorted count];
    int keyTimingPointNum = (int)[beatmap.timingPointsKeySorted count];
    NSMutableSet *timingTimerSet = [[NSMutableSet alloc] initWithCapacity:
                                    (keyTimingPointNum + timingPointNum)];
    int count = [self referanceIndexInAllTimingPoints];
    while (count<timingPointNum) {
        TimingPoint *tp = [beatmap.timingPointsSorted objectAtIndex:count];
        float offset = [tp.offset floatValue] - player.currentTime ;
        if(offset>0){
            NSTimer *timer = [NSTimer timerWithTimeInterval:offset target:self
                                                   selector:@selector(musicPlayerDidMeetTimingPoint:) userInfo:nil repeats:NO];
            [timingTimerSet addObject:timer];
        }
        count++;
    }
    count = [self referanceIndexInKeyTimingPoints];
    while (count<keyTimingPointNum) {
        TimingPoint *tp = [beatmap.timingPointsKeySorted objectAtIndex:count];
        float offset = [tp.offset floatValue] - player.currentTime ;
        if(offset>0){
        NSTimer *timer = [NSTimer timerWithTimeInterval:offset target:self
                                               selector:@selector(musicPlayerDidMeetKeyTimingPoint:) userInfo:nil repeats:NO];
        [timingTimerSet addObject:timer];
        }
        count++;
    }
    [timingTimerSet enumerateObjectsUsingBlock:^(NSTimer *timer,BOOL *stop){
        
        [timer fire];
    }];
    [player play];
}
- (NSTimeInterval)currentTime{
    return [player currentTime];
}
- (NSTimeInterval)timeToNextBeat{
    int index = [self currentIndexInKeyTimingPoints];
    if (index == -1) {
        TimingPoint *timingPoint = [mapPlaying.timingPointsKeySorted firstObject];
        float offset = [[timingPoint offset] floatValue];
        return offset - player.currentTime;
    }else if (index == -100){
        return -1;
    }else if(index >= 0){
        TimingPoint *timingPoint = [mapPlaying.timingPointsKeySorted objectAtIndex:index];
        float offset = [[timingPoint offset] floatValue];
        float spb = 1 / [[timingPoint bps] floatValue];
        return ( spb - (fmod(player.currentTime - offset,spb))   );
    }else{
        return 0;
    }
}
- (BOOL)isPlaying{
    return [player isPlaying];
}
- (int)currentIndexInKeyTimingPoints{
    NSArray *pointSet =   mapPlaying.timingPointsKeySorted;
    int timingPointNum = (int)[pointSet count] ;
    TimingPoint *point = [pointSet firstObject];
    if (player.currentTime < [[point offset] floatValue]) {
        return -1;
    }
    int index= 0;
    for (;index < timingPointNum; index++) {
        
        point = [pointSet objectAtIndex:index];
        
        if (player.currentTime >= [[point offset] floatValue]) {
            return index;
        }
    }
    return -100;
}
- (int)currentIndexInAllTimingPoints{
    NSArray *pointSet =   mapPlaying.timingPointsSorted;
    int timingPointNum = (int)[pointSet count] ;
    TimingPoint *point = [pointSet firstObject];
    if (player.currentTime < [[point offset] floatValue]) {
        return -1;
    }
    int index= 0;
    for (;index < timingPointNum; index++) {
        point = [pointSet objectAtIndex:index];
        if (player.currentTime >= [[point offset] floatValue]) {
            return index;
        }
    }
    return -100;
}
- (int)referanceIndexInKeyTimingPoints{
    int index = [self currentIndexInKeyTimingPoints];
    if (index<0) {
        index=0;
    }
    return index;
}
- (int)referanceIndexInAllTimingPoints{
    int index = [self currentIndexInAllTimingPoints];
    if (index<0) {
        index=0;
    }
    return index;
}
- (void)musicPlayerDidMeetTimingPoint:(NSTimer *)timer{
    DoMeetTimingPoint(mapPlaying);
}
- (void)musicPlayerDidMeetKeyTimingPoint:(NSTimer *)timer{
    DoMeetKeyTimingPoint(mapPlaying);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (DoWillEndPlaying != nil) {
        DoWillEndPlaying(mapPlaying);
    }
    //!-Add codes below -!//
    
    if (      self.endMode == GlobalMusicPlayerEndModeRandom) {
        [self playRandomInSet:importBeatmapSet];
    }else if (self.endMode == GlobalMusicPlayerEndModeAgain){
        [self playBeatmap:mapPlaying];
    }else if (self.endMode == GlobalMusicPlayerEndModeStop){
        
    }
    
    //!-Add codes behind -!//
    if (DoDidEndPlaying != nil) {
        DoDidEndPlaying(mapPlaying);
    }
}
@end
