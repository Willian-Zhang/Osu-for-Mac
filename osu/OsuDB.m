//
//  OsuDB.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-10.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "OsuDB.h"
#import "Beatmap.h"
#import "BTBinaryStreamReader.h"

@implementation OsuDB

@dynamic dir;
@dynamic lastImport;
@dynamic lastLogin;
@dynamic numOfBeatmaps;
@dynamic numOfMapSets;
@dynamic username;
@dynamic savable;
@dynamic isImported;
@dynamic isNew;
@dynamic lastUpdate;
@dynamic beatmaps;

- (BOOL)isUpToDate{
    
    return NO;
}
- (OsuDB *)importDatabaseUsing:(BTBinaryStreamReader *)reader error:(NSError **)error//add
{
    [self setLastLogin:                                     [reader readDateByInt32]];
    [self setNumOfMapSets:[NSNumber numberWithInt:          [reader readInt32]]];
                                                            [reader readDataOfLength:1];
                                                            [reader readInt64];
    [self setUsername:                                      [reader readStringByWillian]];
    
    NSInteger endSkip;
    if (self.username == nil || [self.username isEqual:@""]) {
        endSkip = 5;
    }else{
        endSkip = 6;
    }
    int numOfBeatmaps =                                   [reader readInt32];
    [self setNumOfBeatmaps:[NSNumber numberWithInt:        numOfBeatmaps]];
    if (numOfBeatmaps>0) {
        NSMutableSet *beatmapSet;
        beatmapSet = [[NSMutableSet alloc] initWithCapacity:numOfBeatmaps];
        for (int mapCount = 0; mapCount<numOfBeatmaps; mapCount++) {
            Beatmap *beatmap = [[NSEntityDescription insertNewObjectForEntityForName:@"Beatmap" inManagedObjectContext:self.managedObjectContext]
                                importBeatmapUsing:reader withEndSkip:endSkip];
            [beatmapSet addObject:beatmap];
        }
        [self addBeatmaps:beatmapSet];
    }else{
        //*error =
    }
    return self;
}

@end
