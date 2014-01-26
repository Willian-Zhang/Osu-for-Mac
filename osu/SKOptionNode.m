//
//  SKOptionNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-1-27.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKOptionNode.h"

@implementation SKOptionNode

- (id)initWithOff
{
    self = [super init];
    if (self) {
        state = NO;
    }
    return self;
}
- (id)initWithOn
{
    self = [super init];
    if (self) {
        state = YES;
    }
    return self;
}

- (SKSpriteNode *)optionBox{
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:CGSizeMake(30, 30)];
    
    return box;
}
@end
