//
//  Beatmap.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-8.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "Beatmap.h"
#import "ImportedOsuDB.h"
#import "TimingPoint.h"

#import "BTBinaryStreamReader.h"

@implementation Beatmap

@dynamic ar;
@dynamic artist;
@dynamic artistU;
@dynamic audioOffset;
@dynamic beatmapId;
@dynamic beatmapSetId;
@dynamic bgDim;
@dynamic circles;
@dynamic cs;
@dynamic creator;
@dynamic difficulty;
@dynamic dir;
@dynamic disableHitSounds;
@dynamic disableSB;
@dynamic disableSkin;
@dynamic drainingTime;
@dynamic endSkip;
@dynamic file;
@dynamic hp;
@dynamic isOSZ2;
@dynamic lastEdit;
@dynamic lastPlayed;
@dynamic lastSync;
@dynamic letterbox;
@dynamic mode;
@dynamic mp3;
@dynamic od;
@dynamic offset;
@dynamic osuHash;
@dynamic played;
@dynamic possiblyBgDimSwitch;
@dynamic previewTime;
@dynamic ratings;
@dynamic sliderMulti;
@dynamic sliders;
@dynamic source;
@dynamic spinners;
@dynamic stackLeniency;
@dynamic state;
@dynamic tags;
@dynamic threadID;
@dynamic timmingPointNumber;
@dynamic title;
@dynamic titleU;
@dynamic totalTime;
@dynamic dbSource;
@dynamic timingPoints;


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
    [beatmap setCs:[NSNumber numberWithInt:             [reader readInt8]]];
    [beatmap setHp:[NSNumber numberWithInt:             [reader readInt8]]];
    [beatmap setOd:[NSNumber numberWithInt:             [reader readInt8]]];
    [beatmap setSliderMulti:[NSNumber numberWithDouble: [reader readDouble]]];
    [beatmap setDrainingTime:[NSNumber numberWithInt:   [reader readInt32]]];
    [beatmap setTotalTime:[NSNumber numberWithInt:      [reader readInt32]]];
    [beatmap setPreviewTime:[NSNumber numberWithInt:    [reader readInt32]]];
    
    int timingPointNumber =                             [reader readInt32];
    
    [beatmap setTimmingPointNumber:[NSNumber numberWithInt:     timingPointNumber]];
    if (timingPointNumber > 0) {
        NSMutableSet *timingPointsSet = [[NSMutableSet alloc] initWithCapacity:timingPointNumber];
        for (int pointCount = 0; pointCount<timingPointNumber; pointCount++) {
            
            TimingPoint *timingPoint = [NSEntityDescription insertNewObjectForEntityForName:@"TimingPoint" inManagedObjectContext:self.managedObjectContext];
            timingPoint = [timingPoint importTo:timingPoint Using:reader];
            [timingPointsSet addObject:timingPoint];
        }
        [beatmap addTimingPoints:timingPointsSet];
        
    }
    
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
