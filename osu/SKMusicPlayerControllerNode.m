//
//  SKMusicPlayerControllerNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKMusicPlayerControllerNode.h"
#import "MPCNextNode.h"

#define buttonSize 31

@implementation SKMusicPlayerControllerNode

- (id)init
{
    self = [super init];
    if (self) {
        [self addNext];
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
}
- (void)addNext{
    next = [[MPCNextNode alloc] init];
    next.position = [self buttonPositionForReversedCount:2];
    next.userInteractionEnabled = YES;
    //[self.scene.view.window makeFirstResponder:next];
    //next.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:buttonSize/2];
    [self addChild:next];
}
- (CGPoint)buttonPositionForReversedCount:(int)count{
    int gap = 10;
    return CGPointMake(- (buttonSize + gap) * count + buttonSize * 0.5,
                       - buttonSize * 0.5 - gap);
}
- (void)mouseEntered:(NSEvent *)theEvent{
    
}
- (void)mouseDown:(NSEvent *)theEvent{
    CGPoint location =  [theEvent locationInNode:self];
    for (SKNode *node in self.children) {
        if ([node isUserInteractionEnabled]) {
            if ([node containsPoint:location]) {
                [node mouseDown:theEvent];
            }
        }
    }
}
@end
