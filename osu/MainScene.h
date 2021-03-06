//
//  MainScene.h
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"

@class FirstRunWindowController;

@class SKMusicPlayerControllerNode;
@class TheBigOSU;

@interface MainScene : SKSceneWithAdditions{
    
    
    TheBigOSU *theBigOSU;
    
    FirstRunWindowController *firstRunController;
    SKMusicPlayerControllerNode *musicControllerNode;
}
- (void)initBGM;
- (void)displayFirstRun;

@end
