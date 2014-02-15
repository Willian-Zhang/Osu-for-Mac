//
//  Beatmap.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-10.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "Beatmap.h"
#import "DBTimingPoint.h"
#import "OsuDB.h"

#import "BTBinaryStreamReader.h"//add
#import "OsuFile.h"//add

@implementation Beatmap

@dynamic ar;
@dynamic artist;
@dynamic artistU;
@dynamic audioOffset;
@dynamic beatmapId;
@dynamic beatmapSetId;
@dynamic bgDim;
@dynamic circles;
@dynamic creator;
@dynamic cs;
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
@dynamic timingPointNumber;
@dynamic title;
@dynamic titleU;
@dynamic totalTime;
@dynamic dbSource;
@dynamic timingPoints;

/*add
 */
- (Beatmap *)importBeatmapUsing:(BTBinaryStreamReader *)reader withEndSkip:(NSUInteger)endSkip
{
    [self setArtist:                                 [reader readStringByWillian]];
    [self setArtistU:                                [reader readStringByWillian]];// possibly nil
    [self setTitle:                                  [reader readStringByWillian]];
    [self setTitleU:                                 [reader readStringByWillian]];// possibly nil
    
    [self setCreator:                                [reader readStringByWillian]];
    [self setDifficulty:                             [reader readStringByWillian]];
    [self setMp3:                                    [reader readStringByWillian]];
    [self setOsuHash:                                [reader readStringByWillian]];
    [self setFile:                                   [reader readStringByWillian]];
    [self setState:                                  [NSNumber numberWithInt:[reader readInt8]]];
    [self setCircles:[NSNumber numberWithInt:        [reader readInt16]]];
    
    
    [self setSliders:[NSNumber numberWithInt:        [reader readInt16]]];
    [self setSpinners:[NSNumber numberWithInt:       [reader readInt16]]];
    [self setLastEdit:                               [reader readDateByInt64]];
    
    [self setAr:[NSNumber numberWithInt:             [reader readInt8]]];
    [self setCs:[NSNumber numberWithInt:             [reader readInt8]]];
    [self setHp:[NSNumber numberWithInt:             [reader readInt8]]];
    [self setOd:[NSNumber numberWithInt:             [reader readInt8]]];
    [self setSliderMulti:[NSNumber numberWithDouble: [reader readDouble]]];
    [self setDrainingTime:[NSNumber numberWithInt:   [reader readInt32]]];
    [self setTotalTime:[NSNumber numberWithInt:      [reader readInt32]]];
    [self setPreviewTime:[NSNumber numberWithInt:    [reader readInt32]]];
    
    int timingPointNumber =                             [reader readInt32];
    
    [self setTimingPointNumber:[NSNumber numberWithInt:timingPointNumber]];
    if (timingPointNumber > 0) {
        NSMutableSet *timingPointsSet = [[NSMutableSet alloc] initWithCapacity:timingPointNumber];
        for (int pointCount = 0; pointCount<timingPointNumber; pointCount++) {
            DBTimingPoint *timingPoint = [[NSEntityDescription insertNewObjectForEntityForName:@"BeatmapTimingPoint" inManagedObjectContext:self.managedObjectContext]
                                          importTimingPointUsing:reader];
            [timingPointsSet addObject:timingPoint];
        }
        [self addTimingPoints:timingPointsSet];
    }
    
    [self setBeatmapId:[NSNumber numberWithInt:              [reader readInt32]]];
    [self setBeatmapSetId:[NSNumber numberWithInt:           [reader readInt32]]];
    
    [self setThreadID:[NSNumber numberWithInt:               [reader readInt32]]];
    [self setRatings:[NSNumber numberWithInt:                [reader readInt32]]];
    [self setOffset:[NSNumber numberWithInt:                 [reader readInt16]]];;
    [self setStackLeniency:[NSNumber numberWithFloat:        [reader readFloat]]];
    [self setMode:[NSNumber numberWithInt:                   [reader readInt8]]];
    [self setSource:                                         [reader readStringByWillian]];
    [self setTags:                                           [reader readStringByWillian]];
    [self setAudioOffset:[NSNumber numberWithInt:            [reader readInt16]]];
    [self setLetterbox:                                      [reader readStringByWillian]];
    [self setPlayed:[NSNumber numberWithInt:                 [reader readInt8]]];//BOOL
    [self setLastPlayed:                                     [reader readDateByInt64]];
    [self setIsOSZ2:[NSNumber numberWithInt:                 [reader readInt8]]];//BOOL
    [self setDir:[                                           [reader readStringByWillian] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    [self setLastSync:                                       [reader readDateByInt64]];
    [self setDisableHitSounds:[NSNumber numberWithInt:       [reader readInt8]]];//BOOL
    [self setDisableSkin:[NSNumber numberWithInt:            [reader readInt8]]];//BOOL
    [self setDisableSB:[NSNumber numberWithInt:              [reader readInt8]]];//BOOL
    [self setPossiblyBgDimSwitch:[NSNumber numberWithInt:    [reader readInt8]]];//DK
    [self setBgDim:[NSNumber numberWithInt:                  [reader readInt16]]];
    [self setEndSkip:                                        [reader readDataOfLength:endSkip]];//DK
    
    return self;
}
@synthesize allTimingPointsSorted;
- (NSArray *)allTimingPointsSorted
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"offset" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    return [self.timingPoints  sortedArrayUsingDescriptors:sortArray];
}
@synthesize keyTimingPointsSorted;
- (NSArray *)keyTimingPointsSorted
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"keyTiming = YES"];
    return [[self allTimingPointsSorted] filteredArrayUsingPredicate:predicate];
}

- (int)indexAt:(NSTimeInterval)time ofTimePoints:(NSArray *)timingPointSet{
    int timingPointNum = (int)[timingPointSet count] ;
    DBTimingPoint *point = [timingPointSet firstObject];
    if (time < [[point offset] floatValue]) {
        return -1;
    }
    int index= 0;
    for (;index < timingPointNum; index++) {
        point = [timingPointSet objectAtIndex:index];
        if (time >= [[point offset] floatValue]) {
            return index;
        }
    }
    return 0;//when first and only offset is below 0
}
- (int)indexOfKeyTimingPointsAt:(NSTimeInterval)time{
    return [self indexAt:time ofTimePoints:[self keyTimingPointsSorted]];
}
- (int)indexOfAllTimingPointsAt:(NSTimeInterval)time{
    return [self indexAt:time ofTimePoints:[self allTimingPointsSorted]];
}

@synthesize osuFile;
- (OsuFile *)osuFile{
    OsuFile *osu = [[OsuFile alloc] init];
    return osu;
}
@synthesize mp3URL;
- (NSURL *)mp3URL{
    return [[[NSURL URLWithString:self.dbSource.dir] URLByAppendingPathComponent:self.dir] URLByAppendingPathComponent:self.mp3];
}
@synthesize osuURL;
- (NSURL *)osuURL{
    return [[[NSURL URLWithString:self.dbSource.dir] URLByAppendingPathComponent:self.dir] URLByAppendingPathComponent:self.file];
}
/*add end
 */
@end
