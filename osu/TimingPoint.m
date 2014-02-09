//
//  TimingPoint.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-8.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "TimingPoint.h"
#import "Beatmap.h"
#import "BTBinaryStreamReader.h"

@implementation TimingPoint

@dynamic bps;
@dynamic offset;
@dynamic keyTiming;
@dynamic bpsMutiplier;
@dynamic beatmap;

- (TimingPoint *)importTo:(TimingPoint *)timingPoint Using:(BTBinaryStreamReader *)reader{
    float badBPM =                                          [reader readDouble];
    if (badBPM >= 0) {
        float bps = 1000.0 /  badBPM;
        [timingPoint setBps:[NSNumber numberWithFloat:bps]];
    }else{
        float mutiplier = -100.0 / badBPM;
        [timingPoint setBpsMutiplier:[NSNumber numberWithFloat:mutiplier]];
    }
    [timingPoint setOffset:[NSNumber numberWithFloat:       [reader readDouble] * 0.001]];
    [timingPoint setKeyTiming:[NSNumber numberWithInt:      [reader readInt8]]];
    return timingPoint;
}

@end
