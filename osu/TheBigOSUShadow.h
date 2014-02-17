//
//  TheBigOSUShadow.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-16.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TheBigOSUShadow : SKNode{
    SKTexture *theBigOSUTexture;
    SKAction *theShadowAction;
    SKSpriteNode *node;
}

- (id)initWithSize:(CGSize )size;
- (void)runAction;
//- (void)resizeTo:(float)size;
- (void)popWithSize:(CGSize )size;

@end
