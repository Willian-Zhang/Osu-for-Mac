//
//  SingleSongSelectScene.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-1.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"
#import <AVFoundation/AVFoundation.h>

@class ApplicationSupport;
@interface SingleSongSelectScene : SKSceneWithAdditions{
    NSURL *loadSongsDirectory;
    NSDictionary *osuDB;
    NSString *currentBeatmapId;
    NSString *currentBeatmapSetId;
    NSInteger currentBeatmapIndex;
    ApplicationSupport *appSupport;
}
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

@end
