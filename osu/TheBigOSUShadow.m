//
//  TheBigOSUShadow.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-16.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#define originalShadowAlpha 0.3
#import "TheBigOSUShadow.h"

@implementation TheBigOSUShadow


- (id)init
{
    self = [super init];
    if (self) {
        theBigOSUTexture = [SKTexture textureWithImageNamed:@"menu-osu"];
        node = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture];
        node.alpha = originalShadowAlpha;
        [self addChild:node];
        
        theShadowAction = [SKAction sequence:@[[SKAction group:@[
                                                                 [SKAction scaleTo:1.04 duration:1],
                                                                 [SKAction fadeAlphaTo:0.02 duration:1]
                                                                 ]],
                                               [SKAction removeFromParent]
                                               ]];
        [theShadowAction setTimingMode:SKActionTimingEaseOut];
    }
    return self;
}
- (void)runAction{
    [node runAction:theShadowAction];
}
- (void)popWithSize:(CGSize )size{
    node = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture size:size];
    node.alpha = originalShadowAlpha;
    [self addChild:node];
    [self runAction];
}
@end
