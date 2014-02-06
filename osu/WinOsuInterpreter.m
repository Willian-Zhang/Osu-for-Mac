//
//  WinOsuInterpreter.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "WinOsuInterpreter.h"
#import "BTBinaryTools.h"

@implementation WinOsuInterpreter


- (BOOL)importDatabaseFromWindowsVersionOsuDB:(NSURL *)databaseURL{
    return [self importDatabaseFromWindowsVersionOsuDB:databaseURL withReport:nil];
}
- (BOOL)importDatabaseFromWindowsVersionOsuDB:(NSURL *)databaseURL withReport:(WinImportingBlock)reportBlock{
    //Block
    Importing = reportBlock;
    
    //Inits
    NSMutableDictionary *database = [[NSMutableDictionary alloc] init];
    NSMutableArray *beatmapArray;
    //NSMutableDictionary *beatmapInf = [[NSMutableDictionary alloc] init];
    NSInteger endSkip;

    //Setting
    CFByteOrder byteOrder = CFByteOrderLittleEndian;
    NSData *data = [[NSData alloc] initWithContentsOfURL:databaseURL];
    BTBinaryStreamReader *reader = [[BTBinaryStreamReader alloc] initWithData:data andSourceByteOrder:byteOrder];
    
    
    //Begin!!
    [database setObject:[NSString stringWithFormat:@"%d",reader.readInt32] forKey:@"lastLogin"];
    [database setObject:[NSString stringWithFormat:@"%d",reader.readInt32] forKey:@"numOfMapsets"];
    [reader readDataOfLength:1];
    [reader readInt64];
    NSString *username = [self getStringUsing:reader];
    [database setObject:username forKey:@"username"];
    if (username == nil) {
        endSkip = 5;
    }else{
        endSkip = 6;
    }
    int32_t numOfMaps = reader.readInt32;
    [database setObject:[NSString stringWithFormat:@"%d",numOfMaps] forKey:@"numOfMaps"];
    
    beatmapArray = [[NSMutableArray alloc] initWithCapacity:numOfMaps];
    for (int mapCount = 0; mapCount<numOfMaps; mapCount++) {
        NSDictionary *beatmap = [self getBeatmapUsing:reader withEndSkip:endSkip];
        [beatmapArray addObject:beatmap];
    }
    [database setObject:beatmapArray forKey:@"beatmapArray"];
    
//    if ([ApplicationSupport write:database]) {
//        return YES;
//    }
    return NO;
}
- (NSMutableDictionary *)getBeatmapUsing:(BTBinaryStreamReader *)reader withEndSkip:(NSUInteger)endSkip{
    NSMutableDictionary *beatmap = [[NSMutableDictionary alloc] init];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"artist"];
    NSString *artistU =         [self getStringUsing:reader];
    if (artistU != nil) {
        [beatmap setObject:[NSString stringWithFormat:@"%@",artistU] forKey:@"artistU"];
    }
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"title"];
    NSString *titleU =          [self getStringUsing:reader];
    if (titleU != nil) {
        [beatmap setObject:[NSString stringWithFormat:@"%@",titleU] forKey:@"titleU"];
    }
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"creator"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"difficulty"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"mp3"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"hash"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"file"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"state"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt16]] forKey:@"circles"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt16]] forKey:@"sliders"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt16]] forKey:@"spinners"];
    [beatmap setObject:[NSString stringWithFormat:@"%lld",[reader readInt64]] forKey:@"lastEdit"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"AR"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"circleSize"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"HPDR"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"OD"];
    [beatmap setObject:[NSString stringWithFormat:@"%f",[reader readDouble]] forKey:@"sliderMulti"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt32]] forKey:@"drainingTime"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt32]] forKey:@"totalTime"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt32]] forKey:@"previewTime"];
    int32_t timmingPoints = [reader readUInt32];
    [reader readDataOfLength:(0x11 * timmingPoints)];
        
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readUInt32]] forKey:@"beatmapId"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readUInt32]] forKey:@"beatmapSetId"];

    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt32]] forKey:@"threadID"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt32]] forKey:@"ratings"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt16]] forKey:@"offset"];;
    [beatmap setObject:[NSString stringWithFormat:@"%f",[reader readFloat]] forKey:@"stackLeniency"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"mode"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"source"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"tags"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt16]] forKey:@"audioOffset"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"letterbox"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"played"];
    [beatmap setObject:[NSString stringWithFormat:@"%lld",[reader readInt64]] forKey:@"lastPlayed"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"isOSZ2"];
    [beatmap setObject:[NSString stringWithFormat:@"%@",[self getStringUsing:reader]] forKey:@"dir"];
    [beatmap setObject:[NSString stringWithFormat:@"%lld",[reader readInt64]] forKey:@"lastSync"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"disableHitSounds"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"disableSkin"];
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt8]] forKey:@"disableSB"];
    [reader readInt8];//DK
    [beatmap setObject:[NSString stringWithFormat:@"%d",[reader readInt16]] forKey:@"BGDim"];
    [reader readDataOfLength:endSkip];//DK
    
    return beatmap;
}
- (NSString *)getStringUsing:(BTBinaryStreamReader *)reader{
    NSInteger stringPrefix = (int)([reader readInt8]);
    if (stringPrefix == 0x0b) {
        NSUInteger readLength = (UInt8)([reader readInt8]);
        if (readLength == 0x00) {
            return nil;
        }
        for (NSUInteger readLengthMore, count = 0 ; readLength >= 0x80 & readLengthMore >= 0x80; count++) { //循环仅保证 不经过 与 经过一次 安全
            readLengthMore = (UInt8)([reader readInt8]);
            readLength += (readLengthMore << (7* (count+1) )) - 0x80 * (count+1);
        }
        return [reader readStringWithEncoding:NSUTF8StringEncoding andLength:readLength];
    }else if (stringPrefix == 0x00){
        return nil;
    }
    return nil;
}


@end
