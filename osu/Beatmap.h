//
//  Beatmap.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-4.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BTBinaryStreamReader;
@class ApplicationSupport;

@interface Beatmap : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * artistU;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleU;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSString * difficulty;
@property (nonatomic, retain) NSString * mp3;
@property (nonatomic, retain) NSString * osuHash;
@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * circles;
@property (nonatomic, retain) NSNumber * sliders;
@property (nonatomic, retain) NSNumber * spinners;
@property (nonatomic, retain) NSDate * lastEdit;
@property (nonatomic, retain) NSNumber * ar;
@property (nonatomic, retain) NSNumber * circleSize;
@property (nonatomic, retain) NSNumber * hpDR;
@property (nonatomic, retain) NSNumber * od;
@property (nonatomic, retain) NSNumber * sliderMulti;
@property (nonatomic, retain) NSNumber * drainingTime;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) NSNumber * previewTime;
@property (nonatomic, retain) NSNumber * beatmapSetId;
@property (nonatomic, retain) NSNumber * beatmapId;
@property (nonatomic, retain) NSNumber * threadID;
@property (nonatomic, retain) NSNumber * ratings;
@property (nonatomic, retain) NSNumber * offset;
@property (nonatomic, retain) NSNumber * stackLeniency;
@property (nonatomic, retain) NSNumber * mode;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSNumber * audioOffset;
@property (nonatomic, retain) NSString * letterbox;
@property (nonatomic, retain) NSNumber * played;
@property (nonatomic, retain) NSDate * lastPlayed;
@property (nonatomic, retain) NSNumber * isOSZ2;
@property (nonatomic, retain) NSString * dir;
@property (nonatomic, retain) NSDate * lastSync;
@property (nonatomic, retain) NSNumber * disableHitSounds;
@property (nonatomic, retain) NSNumber * disableSkin;
@property (nonatomic, retain) NSNumber * disableSB;
@property (nonatomic, retain) NSNumber * possiblyBgDimSwitch;
@property (nonatomic, retain) NSNumber * bgDim;
@property (nonatomic, retain) NSData * endSkip;
@property (nonatomic, retain) NSNumber * timmingPoints;
@property (nonatomic, retain) NSData * timmingPointContents;

- (Beatmap *)importTo:(Beatmap *)beatmap Using:(BTBinaryStreamReader *)reader withEndSkip:(NSUInteger )endSkip;

@end
