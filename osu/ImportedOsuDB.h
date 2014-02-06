//
//  ImportedOsuDB.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-5.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beatmap;

@interface ImportedOsuDB : NSManagedObject

@property (nonatomic, retain) NSDate * lastImport;
@property (nonatomic, retain) NSDate * lastLogin;
@property (nonatomic, retain) NSNumber * numOfBeatmaps;
@property (nonatomic, retain) NSNumber * numOfMapSets;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *importedBeatmaps;
@end

@interface ImportedOsuDB (CoreDataGeneratedAccessors)

- (void)addImportedBeatmapsObject:(Beatmap *)value;
- (void)removeImportedBeatmapsObject:(Beatmap *)value;
- (void)addImportedBeatmaps:(NSSet *)values;
- (void)removeImportedBeatmaps:(NSSet *)values;

@end
