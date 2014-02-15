//
//  GlobalMusicPlayer.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "GlobalMusicPlayer.h"
#include <math.h>

#import "AppDelegate.h"
#import "ApplicationSupport.h"
#import "SettingsDealer.h"

#import "Beatmap.h"
#import "DBTimingPoint.h"

@implementation GlobalMusicPlayer

@synthesize mapPlaying;
@synthesize eventDelegate;
@synthesize modeDelegate;
@synthesize volume;

- (id)init
{
    self = [super init];
    if (self) {
        [modeDelegate setGMPStartMode:GlobalMusicPlayerStartModeFromClimax];
        [modeDelegate setGMPEndMode:GlobalMusicPlayerEndModeStop];
        
        volume = 0.8;
        settings    = [(AppDelegate *)[[NSApplication sharedApplication] delegate] settings];
        appSupport  = [(AppDelegate *)[[NSApplication sharedApplication] delegate] appSupport];
    }
    return self;
}


- (void)playRandom{
    if (![appSupport isAllBeatmapsReady]) {
        [eventDelegate errorOccurred:NSLocalizedString(@"Something is wrong. Try to go to \"Play → Solo\"!", @"Error occured in PlayRandom")];
        return;
    }
    NSSet *beatmapSet = [appSupport getSetOfAllBeatmaps];
    NSInteger maxBeatmapNumber = beatmapSet.count;
    NSInteger randBeatmapIndex = arc4random()%maxBeatmapNumber;
    Beatmap *beatmap = [[beatmapSet allObjects] objectAtIndex:randBeatmapIndex];
    [self playBeatmap:beatmap];
}
- (void)playBeatmap:(Beatmap *)beatmap{
    mapPlaying = beatmap;
    NSURL *mp3URL = [beatmap mp3URL];
    
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:mp3URL error:&error];
    if (error != nil) {
        [eventDelegate errorOccurred:[NSString stringWithFormat:NSLocalizedString(@"Cannot play %@, you may just skip this QAQ", @"Cannot play mp3 file label"),beatmap.title]];
        return;
    }
    player.numberOfLoops = 0;
    if (modeDelegate.GMPStartMode == GlobalMusicPlayerStartModeFromClimax) {
        float previewTime = [beatmap.previewTime intValue] * 0.001;
        player.currentTime = previewTime;
    }
    player.delegate = self;
    player.volume = volume;
    [player prepareToPlay];
    
    /*Timers
     */
    int allTimingPointNum   = (int)[beatmap.allTimingPointsSorted count];
    int keyTimingPointNum   = (int)[beatmap.keyTimingPointsSorted count];
    timingTimerSet = [[NSMutableSet alloc] initWithCapacity:(keyTimingPointNum + allTimingPointNum)];
    int count = [self referanceIndexInAllTimingPoints];
    while (count<allTimingPointNum) {
        DBTimingPoint *tp = [beatmap.allTimingPointsSorted objectAtIndex:count];
        float offset = [tp.offset floatValue] - player.currentTime ;
        if(offset>0){
            NSTimer *timer = [NSTimer timerWithTimeInterval:offset target:self
                                                   selector:@selector(GMPdidMeetAnyTimingPoint) userInfo:nil repeats:NO];
            [timingTimerSet addObject:timer];
        }
        count++;
    }
    count = [self referanceIndexInKeyTimingPoints];
    while (count<keyTimingPointNum) {
        DBTimingPoint *tp = [beatmap.keyTimingPointsSorted objectAtIndex:count];
        float offset = [tp.offset floatValue] - player.currentTime ;
        if(offset>0){
            NSTimer *timer = [NSTimer timerWithTimeInterval:offset target:self
                                                   selector:@selector(GMPdidMeetKeyTimingPoint) userInfo:nil repeats:NO];
            [timingTimerSet addObject:timer];
        }
        count++;
    }
    [timingTimerSet enumerateObjectsUsingBlock:^(NSTimer *timer,BOOL *stop){
        [timer fire];
    }];
    [player play];
}
- (void)GMPdidMeetAnyTimingPoint{
    if ([eventDelegate respondsToSelector:@selector(GMPdidMeetAnyTimingPointFor:)]) {
        [eventDelegate GMPdidMeetAnyTimingPointFor:mapPlaying];
    }
}
- (void)GMPdidMeetKeyTimingPoint{
    if ([eventDelegate respondsToSelector:@selector(GMPdidMeetKeyTimingPointFor:)]) {
        [eventDelegate GMPdidMeetKeyTimingPointFor:mapPlaying];
    }
}

- (NSTimeInterval)timeIntervalToNextBeat{
    int index = [self referanceIndexInKeyTimingPoints];
    DBTimingPoint *timingPoint = [mapPlaying.keyTimingPointsSorted objectAtIndex:index];
    float offset    = [[timingPoint offset] floatValue];
    float spb       = 1 / [[timingPoint bps] floatValue]; // spb = 1/bps
    
    if (index == -1) {
        return fmod(offset - player.currentTime,spb);
    }
    return ( spb - (fmod(player.currentTime - offset,spb))   );
}

- (float)currentBps{
    return [[[mapPlaying.keyTimingPointsSorted objectAtIndex:[self referanceIndexInKeyTimingPoints]] bps] floatValue];
}

- (int)referanceIndexInKeyTimingPoints{
    int index = [mapPlaying indexOfKeyTimingPointsAt:player.currentTime];
    if (index<0) {
        index=0;
    }
    return index;
}
- (int)referanceIndexInAllTimingPoints{
    int index = [mapPlaying indexOfAllTimingPointsAt:player.currentTime];
    if (index<0) {
        return 0;
    }
    return index;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if ([eventDelegate respondsToSelector:@selector(GMPwillEndPlaying:)]) {
        [eventDelegate GMPwillEndPlaying:mapPlaying];
    }
    //!-Add codes below -!//
    GlobalMusicPlayerEndMode endMode =  [modeDelegate GMPEndMode];
    if       (endMode == GlobalMusicPlayerEndModeRandom) {
        [self playRandom];
    }else if (endMode == GlobalMusicPlayerEndModeAgain){
        [self playBeatmap:mapPlaying];
    }else if (endMode == GlobalMusicPlayerEndModeStop){
        
    }
    
    //!-Add codes behind -!//
    if ([eventDelegate respondsToSelector:@selector(GMPdidEndPlayingAndPlays:)]) {
        [eventDelegate GMPdidEndPlayingAndPlays:mapPlaying];
    }
}
- (void)next{
    if ([eventDelegate respondsToSelector:@selector(GMPwillEndPlaying:)]) {
        [eventDelegate GMPwillEndPlaying:mapPlaying];
    }
    [player stop];
    if (modeDelegate.GMPEndMode == GlobalMusicPlayerEndModeRandom) {
        [self playRandom];
    }else if (modeDelegate.GMPEndMode == GlobalMusicPlayerEndModeAgain){
        [self playBeatmap:mapPlaying];
    }
    //
    if ([eventDelegate respondsToSelector:@selector(GMPdidEndPlayingAndPlays:)]) {
        [eventDelegate GMPdidEndPlayingAndPlays:mapPlaying];
    }
}
#pragma mark Player Events

- (float)volume{
    return player.volume;
}
- (void)setVolume:(float)aVolume{
    player.volume = aVolume;
}
- (NSTimeInterval)currentTime{
    return [player currentTime];
}
- (BOOL)isPlaying{
    return [player isPlaying];
}

@end
