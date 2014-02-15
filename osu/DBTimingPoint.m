//
//  DBTimingPoint.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-10.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "DBTimingPoint.h"
#import "Beatmap.h"
#import "BTBinaryStreamReader.h"//add

@implementation DBTimingPoint

@dynamic bps;
@dynamic bpsMutiplier;
@dynamic isKeyTiming;
@dynamic offset;
@dynamic beatmap;

- (DBTimingPoint *)importTimingPointUsing:(BTBinaryStreamReader *)reader//add
{
    float badBPM =                                          [reader readDouble];
    if (badBPM >= 0) {
        float bps = 1000.0 /  badBPM;
        [self setBps:[NSNumber numberWithFloat:bps]];
    }else{
        float mutiplier = -100.0 / badBPM;
        [self setBpsMutiplier:[NSNumber numberWithFloat:mutiplier]];
    }
    [self setOffset:[NSNumber numberWithFloat:       [reader readDouble] * 0.001]];
    [self setIsKeyTiming:[NSNumber numberWithInt:    [reader readInt8]]];
    return self;
}

@end
