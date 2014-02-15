//
//  TimingPoint.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-8.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beatmap;
@class BTBinaryStreamReader;

@interface TimingPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * bps;
@property (nonatomic, retain) NSNumber * offset;
@property (nonatomic, retain) NSNumber * keyTiming;
@property (nonatomic, retain) NSNumber * bpsMutiplier;
@property (nonatomic, retain) Beatmap *beatmap;

- (TimingPoint *)importTo:(TimingPoint *)timingPoint Using:(BTBinaryStreamReader *)reader;
    
@end
