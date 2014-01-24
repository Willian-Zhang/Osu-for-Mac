//
//  MainScene.h
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MainScene : SKScene{
    CGSize sceneSize;
    SKTexture *cursorTexture;
    SKTexture *cursortailTexture;
    SKNode *cursor;
    CGPoint lastFrameCursorPosition;
}

@end
