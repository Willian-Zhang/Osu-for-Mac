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

- (id)initWithSize:(CGSize )size
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        SKTexture *theBigOSUTexture = [SKTexture textureWithImageNamed:@"menu-osu"];
        node = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture size:size];
        [self addChild:node];
        hoverFraction = 1;
    }
    return self;
}

- (void)didMouseEnter{
    hoverFraction = 1.1;
//    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
//    float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * hoverFraction;
    [node runAction:[SKAction scaleTo:hoverFraction duration:0.1]];
}
- (void)didMouseExit{
    hoverFraction = 1;
//    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
//    float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * hoverFraction;
//    [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0.4]];
    [node runAction:[SKAction scaleTo:hoverFraction duration:0.1]];
}
- (void)resizeTo:(float)size{    
    [node runAction:[SKAction resizeToWidth:size height:size duration:0]];
}
@end
