//
//  SKMusicPlayerControllerNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKMusicPlayerControllerNode.h"
#import "SKSceneWithAdditions.h"

#import "MPCNowPlayingNode.h"
#import "MPCNextNode.h"
#import "MPCInfoNode.h"

#define buttonSize 31

@implementation SKMusicPlayerControllerNode
- (void)updateNowPlaying:(NSString *)title
{
    [nowPlaying setText:title];
    [self showInfo];
}
- (void)showInfo
{
    [buttons removeAllActions];
    SKAction *moveDown = [SKAction moveToY:-32 duration:0.1];
    [buttons runAction:moveDown];
    [nowPlaying runAction:[SKAction group:@[
                                            [SKAction fadeAlphaTo:1 duration:0.2],
                                            [SKAction moveToX:-nowPlaying.width duration:0.2]
                                            //[SKAction move]
                                            ]]];
    if (self.infoDisplayMode == MusicPlayerControllerInfoDisplayAutohide) {
        [self prepareToHideInfo];
    }
}
- (void)hideInfo
{
    SKAction *moveUp = [SKAction moveToY:-10 duration:0.8];
    [buttons runAction:moveUp];
    [nowPlaying runAction:[SKAction group:@[
                                            [SKAction fadeAlphaTo:0 duration:0.5],
                                            [SKAction moveToX:-nowPlaying.width+90 duration:0.5]
                                            //[SKAction move]
                                            ]]];
}
- (void)prepareToHideInfo
{
    [buttons runAction:[SKAction sequence:@[
                                            [SKAction waitForDuration:10],
                                            [SKAction runBlock:^(void){ [self hideInfo];}]
                                            ]]];

}
- (void)switchInfoDisplayMode
{
    if (self.infoDisplayMode == MusicPlayerControllerInfoDisplayAutohide) {
        // To Always
        info.alpha = 1;
        self.infoDisplayMode = MusicPlayerControllerInfoDisplayAlways;
        [self showInfo];
    }else{
        info.alpha = 0.5;
        self.infoDisplayMode = MusicPlayerControllerInfoDisplayAutohide;
        [self prepareToHideInfo];
    }
}

- (id)initWithScene:(SKSceneWithAdditions *)scene
{
    self = [super init];
    if (self) {
        callerScene = scene;
        buttons = [[SKNode alloc] init];
        buttons.zPosition = 5;
        buttons.position = CGPointMake(0, -10);
        [self addChild:buttons];
        [self addNowPlaying];
        [self addNext];
        [self addInfo];
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
}
- (void)addButtonMouseOverEventTo:(SKNode<SKNodeMouseOverEvents>*)node{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:node.calculateAccumulatedFrame.size];
    node.physicsBody = body;
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = buttonCategory;
    [callerScene addContact:node];
}
- (void)addNowPlaying
{
    nowPlaying = [[MPCNowPlayingNode alloc] init];
    nowPlaying.position = CGPointZero;
    nowPlaying.alpha = 0;
    [self addChild:nowPlaying];
}
- (void)addNext
{
    next = [[MPCNextNode alloc] init];
    next.position = [self buttonPositionForReversedCount:2];
    [self addButtonMouseOverEventTo:next];
                //[self.scene.view.window makeFirstResponder:next];
                //next.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:buttonSize/2];
    [buttons addChild:next];
}
- (void)addInfo
{
    info = [[MPCInfoNode alloc] init];
    info.position = [self buttonPositionForReversedCount:1];
    info.alpha = 0.5;
    [self addButtonMouseOverEventTo:info];
    [buttons addChild:info];
}
- (CGPoint)buttonPositionForReversedCount:(int)count
{
    int gap = 8;
    return CGPointMake(- (buttonSize + gap) * count + buttonSize * 0.5,
                       - buttonSize * 0.5);
}

- (void)mouseDown:(NSEvent *)theEvent{
    CGPoint location =  [theEvent locationInNode:buttons];
    for (SKNode *node in buttons.children) {
        if ([node isUserInteractionEnabled]) {
            if ([node containsPoint:location]) {
                [node mouseDown:theEvent];
                if (node == info) {
                    [self switchInfoDisplayMode];
                }
            }
        }
    }
}
@end
