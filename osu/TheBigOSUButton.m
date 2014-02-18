//
//  TheBigOSUButton.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-16.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "TheBigOSUButton.h"

#import "SKSceneWithAdditions.h"

@implementation TheBigOSUButton
@synthesize hoverFraction;

- (id)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        SKTexture *theBigOSUTexture = [SKTexture textureWithImageNamed:@"menu-osu"];
        node = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture];
        [self addChild:node];
        hoverFraction = 1;
    }
    return self;
}

- (void)didMouseEnter{
    hoverFraction = 1.1;
    [node runAction:[SKAction scaleTo:hoverFraction duration:0.1]];
}
- (void)didMouseExit{
    hoverFraction = 1;
    [node runAction:[SKAction scaleTo:hoverFraction duration:0.1]];
}
@end
