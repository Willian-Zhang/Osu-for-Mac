//
//  OsuDB.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-10.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beatmap;
@class BTBinaryStreamReader;//add

@interface OsuDB : NSManagedObject

@property (nonatomic, retain) NSString * dir;
@property (nonatomic, retain) NSDate * lastImport;
@property (nonatomic, retain) NSDate * lastLogin;
@property (nonatomic, retain) NSNumber * numOfBeatmaps;
@property (nonatomic, retain) NSNumber * numOfMapSets;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * savable;
@property (nonatomic, retain) NSNumber * isImported;
@property (nonatomic, retain) NSNumber * isNew;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSSet *beatmaps;

- (OsuDB *)importDatabaseUsing:(BTBinaryStreamReader *)reader error:(NSError **)error;//add
@end

@interface OsuDB (CoreDataGeneratedAccessors)

- (void)addBeatmapsObject:(Beatmap *)value;
- (void)removeBeatmapsObject:(Beatmap *)value;
- (void)addBeatmaps:(NSSet *)values;
- (void)removeBeatmaps:(NSSet *)values;

@end
