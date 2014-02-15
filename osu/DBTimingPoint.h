//
//  DBTimingPoint.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-10.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beatmap;
@class BTBinaryStreamReader;//add

@interface DBTimingPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * bps;
@property (nonatomic, retain) NSNumber * bpsMutiplier;
@property (nonatomic, retain) NSNumber * isKeyTiming;
@property (nonatomic, retain) NSNumber * offset;
@property (nonatomic, retain) Beatmap *beatmap;

- (DBTimingPoint *)importTimingPointUsing:(BTBinaryStreamReader *)reader;//add

@end
