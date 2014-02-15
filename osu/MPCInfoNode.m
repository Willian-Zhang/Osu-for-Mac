//
//  MPCInfoNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-15.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "MPCInfoNode.h"

@implementation MPCInfoNode

- (id)init
{
    self = [super init];
    if (self) {
        SKTexture *texture = [SKTexture textureWithImageNamed:@"editor-button-info"];
        [self addChild:[SKSpriteNode spriteNodeWithTexture:texture]];
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
