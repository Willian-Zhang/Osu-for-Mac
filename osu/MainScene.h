//
//  MainScene.h
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FirstRunWindowController.h"
enum{
    FirstRunConfigureFailed  = ConfigureFailed,
    FirstRunConfigureSucceed = ConfigureSucceed
};
@interface MainScene : SKScene{
    CGSize sceneSize;
    SKTexture *cursorTexture;
    SKTexture *cursortailTexture;
    SKNode *cursor;
    CGPoint lastFrameCursorPosition;
    float theBigOSUFraction;
    float theBigOSUMouseHoverFraction;
    FirstRunWindowController *firstRunController;
}
- (void)displayFirstRunSettingsWithCompletion:(void (^)(NSInteger result))block;
- (void)displayMessage:(NSString *)messageString;

@end
