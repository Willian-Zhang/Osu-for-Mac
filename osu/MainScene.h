//
//  MainScene.h
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"
#import "FirstRunWindowController.h"

enum{
    FirstRunConfigureFailed  = ConfigureFailed,
    FirstRunConfigureSucceed = ConfigureSucceed
};

@class SKMusicPlayerControllerNode;
@class TheBigOSU;

@interface MainScene : SKSceneWithAdditions{
    int menuLevel;
    
    float theBigOSUFraction;
    float theBigOSUMouseHoverFraction;
    
    SKSpriteNode  *theBigOSU;
    SKAction      *theBigOSUAction;
    SKSpriteNode  *theBigOSUShadow;
    
    FirstRunWindowController *firstRunController;
    
    SKMusicPlayerControllerNode *musicControllerNode;
}
- (void)initBGM;
- (void)displayFirstRun;
- (void)displayFirstRunSettingsWithCompletion:(void (^)(NSInteger result))block;

@end
