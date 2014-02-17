//
//  GlobalMusicPlayer.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, GlobalMusicPlayerStartMode) {
	GlobalMusicPlayerStartModeFromBegin          = 0,
	GlobalMusicPlayerStartModeFromClimax         = 1
};
typedef NS_ENUM(NSInteger, GlobalMusicPlayerEndMode) {
	GlobalMusicPlayerEndModeStop                = 0,
    GlobalMusicPlayerEndModeAgain               = 1,
    GlobalMusicPlayerEndModeRandom              = 2
    
};

@class Beatmap;

@protocol GMPModeDelegate <NSObject>
@required
@property (readwrite) GlobalMusicPlayerStartMode GMPStartMode;
@property (readwrite) GlobalMusicPlayerEndMode   GMPEndMode;
@end

@protocol GMPEventDelegate <NSObject>
@required
- (void)errorOccurred:(NSString *)errorString;
@optional
- (void)GMPwillEndPlaying:(Beatmap *)beatmap;
- (void)GMPdidEndPlayingAndPlays:(Beatmap *)beatmap;
- (void)GMPdidMeetKeyTimingPointFor:(Beatmap *)beatmap;
- (void)GMPdidMeetAnyTimingPointFor:(Beatmap *)beatmap;
@end

@class SettingsDealer;
@class ApplicationSupport;
@interface GlobalMusicPlayer : NSObject <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    Beatmap *mapPlaying;
    SettingsDealer *settings;
    ApplicationSupport *appSupport;
    NSMutableSet *timingTimerSet;
}
+ (GlobalMusicPlayer *)getGMP;

@property (readwrite) float volume;
@property Beatmap *mapPlaying;

@property (weak) id <GMPEventDelegate> eventDelegate;
@property (weak) id <GMPModeDelegate> modeDelegate;

- (NSTimeInterval)timeIntervalToNextBeat;
- (void)playRandom;
- (void)playBeatmap:(Beatmap *)beatmap;


- (void)next;

- (int)referanceIndexInKeyTimingPoints;
- (int)referanceIndexInAllTimingPoints;
- (NSTimeInterval)currentTime;
- (float)currentBps;

@end
