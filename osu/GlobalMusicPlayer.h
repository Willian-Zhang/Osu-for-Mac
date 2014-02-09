//
//  GlobalMusicPlayer.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, GlobalMusicPlayerMode) {
	GlobalMusicPlayerModeFromBegin          = 0,
	GlobalMusicPlayerModeFromClimax         = 1
};
typedef NS_ENUM(NSInteger, GlobalMusicPlayerEndMode) {
	GlobalMusicPlayerEndModeStop                = 0,
    GlobalMusicPlayerEndModeAgain               = 1,
    GlobalMusicPlayerEndModeRandom              = 2
    
};

@class Beatmap;

typedef void(^GlobalMusicPlayerWillEndPlaying)(Beatmap *);
typedef void(^GlobalMusicPlayerDidEndPlaying)(Beatmap *);
typedef void(^GlobalMusicPlayerDidMeetTimingPoint)(Beatmap *);
typedef void(^GlobalMusicPlayerDidMeetKeyTimingPoint)(Beatmap *);

@interface GlobalMusicPlayer : AVAudioPlayer <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    NSURL *loadSongsDir;
    NSURL *saveSongsDir;
    NSSet *importBeatmapSet;
    Beatmap *mapPlaying;
    GlobalMusicPlayerWillEndPlaying DoWillEndPlaying;
    GlobalMusicPlayerDidEndPlaying  DoDidEndPlaying;
    GlobalMusicPlayerDidMeetTimingPoint     DoMeetTimingPoint;
    GlobalMusicPlayerDidMeetKeyTimingPoint  DoMeetKeyTimingPoint;
}

@property Beatmap *mapPlaying;
@property GlobalMusicPlayerMode playMode;
@property GlobalMusicPlayerEndMode endMode;

- (NSTimeInterval)timeToNextBeat;
- (void)playRandomInSet:(NSSet *)beatmapSet;
- (void)playBeatmap:(Beatmap *)beatmap;
- (void)recieveWillEndPlaying:(GlobalMusicPlayerWillEndPlaying)willEndPlaying
                DidEndPlaying:(GlobalMusicPlayerDidEndPlaying)didEndPlaying;
- (void)recieveMeetTimingPoint:(GlobalMusicPlayerDidMeetTimingPoint)timingPointBlock
                      KeyPoint:(GlobalMusicPlayerDidMeetKeyTimingPoint)keyTimingPintBlock;
- (int)currentIndexInKeyTimingPoints;
- (int)currentIndexInAllTimingPoints;
- (int)referanceIndexInKeyTimingPoints;
- (int)referanceIndexInAllTimingPoints;
@end
