//
//  MPCNextNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-14.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "MPCNextNode.h"
#import "AppDelegate.h"
#import "GlobalMusicPlayer.h"

@implementation MPCNextNode
- (id)init
{
    self = [super init];
    if (self) {
        SKTexture *nextButtonTexture = [SKTexture textureWithImageNamed:@"editor-button-ff"];
        [self addChild:[SKSpriteNode spriteNodeWithTexture:nextButtonTexture]];
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent{
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    GlobalMusicPlayer *GMP = appDelegate.globalMusicPlayer;
    [GMP next];
}
-(void)mouseMoved:(NSEvent *)theEvent{
    [self runAction:[SKAction scaleTo:1.2 duration:0.2]];
}
-(void)mouseEntered:(NSEvent *)theEvent{
    [self runAction:[SKAction scaleTo:1.2 duration:0.2]];
}
-(void)mouseExited:(NSEvent *)theEvent{
    [self runAction:[SKAction scaleTo:1 duration:0.2]];
}
@end
