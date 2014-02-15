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
typedef void(^ScaningCompletion)(BOOL);

@interface ScaningScene : SKSceneWithAdditions{
    ScaningCompletion runCompletionBlock;
    SKNode *loadingLabelGroup;
    SKLabelNode *importLabel;
    ApplicationSupport *appSupport;
}

- (void)makeAllBeatmapsReady:(ScaningCompletion)completionBlock;



@end
