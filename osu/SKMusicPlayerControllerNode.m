//
//  SKMusicPlayerControllerNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKMusicPlayerControllerNode.h"
#import "SKSceneWithAdditions.h"

#define buttonSize 50

@implementation SKMusicPlayerControllerNode

- (id)init:(SKSceneWithAdditions *)sender
{
    self = [super init];
    if (self) {
        callerScene = sender;
        [sender addChild:self];
        [self initNext];
        [self runAction:[SKAction fadeOutWithDuration:20]];
    }
    return self;
}
- (void)initNext{
    SKTexture *nextButtonTexture = [SKTexture textureWithImageNamed:@"nextMusicButton"];
    next = [SKSpriteNode spriteNodeWithTexture:nextButtonTexture size:CGSizeMake(buttonSize, buttonSize)];
    next.position = [self buttonPositionForReverseCount:2];
    [self addChild:next];
}
- (CGPoint)buttonPositionForReverseCount:(int)count{
    int gap = 10;
    return CGPointMake(callerScene.rightMargin - (buttonSize + gap) * count + buttonSize * 0.5
                       , callerScene.topMargin - buttonSize * 0.5 - gap);
}
- (void)resizeMusicController{
    
}
@end
