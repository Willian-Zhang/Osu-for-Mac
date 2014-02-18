//
//  TheBigOSUWave.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-16.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#define originalWaveAlpha 1
#import "TheBigOSUShockwave.h"

@implementation TheBigOSUShockwave

- (id)initWithSize:(CGSize )size
{
    self = [super init];
    if (self) {
        texture = [SKTexture textureWithImageNamed:@"menu-osu-shockwave"];
        node = [SKSpriteNode spriteNodeWithTexture:texture size:size];
        node.alpha = originalWaveAlpha;
        [self addChild:node];
        action = [SKAction sequence:@[[SKAction group:@[
                                                        [SKAction scaleTo:1.3 duration:1],
                                                        [SKAction fadeAlphaTo:0 duration:1]
                                                        ]],
                                      [SKAction removeFromParent]
                                      ]];
    }
    return self;
}
- (void)runAction{
    [node runAction:action];
}
- (void)popWithFrame:(CGRect)frame{
    node = [SKSpriteNode spriteNodeWithTexture:texture size:frame.size];
    node.position = frame.origin;
    node.alpha = originalWaveAlpha;
    [self addChild:node];
    [self runAction];
}
@end
