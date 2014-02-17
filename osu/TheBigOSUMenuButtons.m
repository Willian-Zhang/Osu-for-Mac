//
//  TheBigOSUMenuButtons.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-18.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "TheBigOSUMenuButtons.h"
#import "AppDelegate.h"

@implementation TheBigOSUMenuPlay
- (id)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self addChild: [SKSpriteNode spriteNodeWithImageNamed:@"menu-button-play"]];
    }
    return self;
}
- (void)mouseDown:(NSEvent *)theEvent{
    NSLog(@"Play!");
}
@end
@implementation TheBigOSUMenuExit
- (id)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self addChild:[SKSpriteNode spriteNodeWithImageNamed:@"menu-button-exit"] ];
    }
    return self;
}
- (void)mouseDown:(NSEvent *)theEvent{
    [[(AppDelegate *)[[NSApplication sharedApplication] delegate] window] close];;
}
@end
#define itemGap 10
@implementation TheBigOSUMenuButtons
- (id)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        play = [[TheBigOSUMenuPlay alloc] init];
        play.position = CGPointMake(0, [self yPositionForItemAtIndex:1]);
        [self addChild:play];

        exit = [[TheBigOSUMenuExit alloc] init];
        exit.position = CGPointMake(0, [self yPositionForItemAtIndex:4]);
        [self addChild:exit];
    }
    return self;
}
- (float)yPositionForItemAtIndex:(int)index{
    
    return (itemGap+89)*1.5 - (index-1)* (89+itemGap);
}
- (void)mouseDown:(NSEvent *)theEvent{
    CGPoint location =  [theEvent locationInNode:self];
    for (SKNode *node in self.children) {
        if ([node isUserInteractionEnabled]) {
            if ([node containsPoint:location]) {
                [node runAction:[SKAction playSoundFileNamed:@"menuhit.wav" waitForCompletion:NO]];
                [node mouseDown:theEvent];
            }
        }
    }
}
@end