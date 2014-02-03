//
//  ScaningScene.h
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"

typedef void(^scaningCompletion)();

@interface ScaningScene : SKSceneWithAdditions{
    scaningCompletion runCompletionBlock;
}



- (void)addLoadingLineWithString:(NSString *)aString;
- (void)CompleteLoading;
- (void)loadAllBeatmaps;
@end
