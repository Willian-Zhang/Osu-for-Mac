//
//  Beatmap.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-4.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "Beatmap.h"
#import "BTBinaryStreamReader.h"

@implementation Beatmap

@dynamic artist;
@dynamic artistU;
@dynamic title;
@dynamic titleU;
@dynamic creator;
@dynamic difficulty;
@dynamic mp3;
@dynamic osuHash;
@dynamic file;
@dynamic state;
@dynamic circles;
@dynamic sliders;
@dynamic spinners;
@dynamic lastEdit;
@dynamic ar;
@dynamic circleSize;
@dynamic hpDR;
@dynamic od;
@dynamic sliderMulti;
@dynamic drainingTime;
@dynamic totalTime;
@dynamic previewTime;
@dynamic beatmapSetId;
@dynamic beatmapId;
@dynamic threadID;
@dynamic ratings;
@dynamic offset;
@dynamic stackLeniency;
@dynamic mode;
@dynamic source;
@dynamic tags;
@dynamic audioOffset;
@dynamic letterbox;
@dynamic played;
@dynamic lastPlayed;
@dynamic isOSZ2;
@dynamic dir;
@dynamic lastSync;
@dynamic disableHitSounds;
@dynamic disableSkin;
@dynamic disableSB;
@dynamic possiblyBgDimSwitch;
@dynamic bgDim;
@dynamic endSkip;
@dynamic timmingPoints;
@dynamic timmingPointContents;


- (Beatmap *)importTo:(Beatmap *)beatmap Using:(BTBinaryStreamReader *)reader withEndSkip:(NSUInteger )endSkip{    
    [beatmap setArtist:                                 [reader readStringByWillian]];
    [beatmap setArtistU:                                [reader readStringByWillian]];// possibly nil
    [beatmap setTitle:                                  [reader readStringByWillian]];
    [beatmap setTitleU:                                 [reader readStringByWillian]];// possibly nil
    
    [beatmap setCreator:                                [reader readStringByWillian]];
    [beatmap setDifficulty:                             [reader readStringByWillian]];
    [beatmap setMp3:                                    [reader readStringByWillian]];
    [beatmap setOsuHash:                                [reader readStringByWillian]];
    [beatmap setFile:                                   [reader readStringByWillian]];
    [beatmap setState:                                  [NSNumber numberWithInt:[reader readInt8]]];
    [beatmap setCircles:[NSNumber numberWithInt:        [reader readInt16]]];
    
    
    [beatmap setSliders:[NSNumber numberWithInt:        [reader readInt16]]];
    [beatmap setSpinners:[NSNumber numberWithInt:       [reader readInt16]]];
    [beatmap setLastEdit:                               [reader readDateByInt64]];
    
    [beatmap setAr:[NSNumber numberWithInt:             [reader readInt8]]];
    [beatmap setCircleSize:[NSNumber numberWithInt:     [reader readInt8]]];
    [beatmap setHpDR:[NSNumber numberWithInt:           [reader readInt8]]];
    [beatmap setOd:[NSNumber numberWithInt:             [reader readInt8]]];
    [beatmap setSliderMulti:[NSNumber numberWithDouble: [reader readDouble]]];
    [beatmap setDrainingTime:[NSNumber numberWithInt:   [reader readInt32]]];
    [beatmap setTotalTime:[NSNumber numberWithInt:      [reader readInt32]]];
    [beatmap setPreviewTime:[NSNumber numberWithInt:    [reader readInt32]]];
    
    [beatmap setTimmingPoints:[NSNumber numberWithInt:  [reader readInt32]]];
    [beatmap setTimmingPointContents:                   [reader readDataOfLength:(0x11 * [beatmap.timmingPoints integerValue])]];
    
    [beatmap setBeatmapId:[NSNumber numberWithInt:              [reader readInt32]]];
    [beatmap setBeatmapSetId:[NSNumber numberWithInt:           [reader readInt32]]];
    
    [beatmap setThreadID:[NSNumber numberWithInt:               [reader readInt32]]];
    [beatmap setRatings:[NSNumber numberWithInt:                [reader readInt32]]];
    [beatmap setOffset:[NSNumber numberWithInt:                 [reader readInt16]]];;
    [beatmap setStackLeniency:[NSNumber numberWithFloat:        [reader readFloat]]];
    [beatmap setMode:[NSNumber numberWithInt:                   [reader readInt8]]];
    [beatmap setSource:                                         [reader readStringByWillian]];
    [beatmap setTags:                                           [reader readStringByWillian]];
    [beatmap setAudioOffset:[NSNumber numberWithInt:            [reader readInt16]]];
    [beatmap setLetterbox:                                      [reader readStringByWillian]];
    [beatmap setPlayed:[NSNumber numberWithInt:                 [reader readInt8]]];//BOOL
//    if ([beatmap.title isEqualToString:@"Six Trillion Years and Overnight Story"]) {
//        NSInteger inttt = [reader readInt8];
//        NSLog(@"Lteerbox:%@ , Played: %ld",beatmap.letterbox,(long)inttt);
//        
//    }else{
//        [reader readInt8];
//    }
    [beatmap setLastPlayed:                                     [reader readDateByInt64]];
    [beatmap setIsOSZ2:[NSNumber numberWithInt:                 [reader readInt8]]];//BOOL
    [beatmap setDir:[                                           [reader readStringByWillian] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    [beatmap setLastSync:                                       [reader readDateByInt64]];
    [beatmap setDisableHitSounds:[NSNumber numberWithInt:       [reader readInt8]]];//BOOL
    [beatmap setDisableSkin:[NSNumber numberWithInt:            [reader readInt8]]];//BOOL
    [beatmap setDisableSB:[NSNumber numberWithInt:              [reader readInt8]]];//BOOL
    [beatmap setPossiblyBgDimSwitch:[NSNumber numberWithInt:    [reader readInt8]]];//DK
    [beatmap setBgDim:[NSNumber numberWithInt:                  [reader readInt16]]];
    [beatmap setEndSkip:                                        [reader readDataOfLength:endSkip]];//DK
    
    return beatmap;
}



@end
