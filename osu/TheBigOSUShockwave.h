//
//  TheBigOSUWave.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-16.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TheBigOSUShockwave : SKNode{
    SKTexture *texture;
    SKAction *action;
    SKSpriteNode *node;
}

- (id)initWithSize:(CGSize )size;
- (void)runAction;
- (void)popWithFrame:(CGRect)frame;

@end
