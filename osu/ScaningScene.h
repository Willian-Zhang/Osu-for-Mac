//
//  ScaningScene.h
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"

@class ApplicationSupport;
typedef void(^scaningCompletion)();

@interface ScaningScene : SKSceneWithAdditions{
    scaningCompletion runCompletionBlock;
    SKNode *loadingLabelGroup;
    SKLabelNode *importLabel;
    ApplicationSupport *appSupport;
}



- (void)addLoadingLineWithString:(NSString *)aString;
- (void)loadAllBeatmaps:(scaningCompletion)comletion;

@end
