//
//  TheBigOSUMenuButtons.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-18.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "TheBigOSUMenu.h"
#import "AppDelegate.h"
#import "TheBigOSU.h"


#pragma mark abstract
@implementation TheBigOSUMenuButton
@synthesize image;
- (id)initWithName:(NSString *)imageName rootNode:(TheBigOSU *)node
{
    self = [super init];
    if (self) {
        rootNode = node;
        image = imageName;
        [self setUserInteractionEnabled:YES];
        texture = [SKTexture textureWithImageNamed:image];
        overTexture = [SKTexture textureWithImageNamed:[image stringByAppendingString:@"-over"]];
        [self addChild: [SKSpriteNode spriteNodeWithTexture:texture]];
    }
    return self;
}
-(void)didMouseEnter
{
    [[self children] enumerateObjectsUsingBlock:^(SKSpriteNode *node, NSUInteger index,BOOL *stop){
        [node setTexture:overTexture];
        [node runAction:[SKAction moveToX:40 duration:0.1]];
        
    }];
    [self runAction:[SKAction playSoundFileNamed:@"menuclick.wav" waitForCompletion:NO]];
}
-(void)didMouseExit
{
    [[self children] enumerateObjectsUsingBlock:^(SKSpriteNode *node, NSUInteger index,BOOL *stop){
        [node setTexture:texture];
        [node runAction:[SKAction moveToX:0 duration:0.1]];
    }];
}
@end

@implementation TheBigOSUMenuLevel
- (id)initWithRoot:(TheBigOSU *)node
{
    self = [super init];
    if (self) {
        rootNode = node;
        [self setUserInteractionEnabled:YES];
    }
    return self;
}
- (void)add:(TheBigOSUMenuButton *)button at:(int)index
{
    button.position = CGPointMake(0, [self yPositionForItemAtIndex:index]);
    [self addChild:button];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:button.calculateAccumulatedFrame.size];
    button.physicsBody = body;
    button.physicsBody.dynamic = NO;
    button.physicsBody.categoryBitMask = buttonCategory;
    [[rootNode callerScene] addContact:button];
}
- (float)yPositionForItemAtIndex:(int)index
{
    return 0;
}
- (void)mouseDown:(NSEvent *)theEvent
{
    CGPoint location =  [theEvent locationInNode:self];
    for (SKNode *node in self.children) {
        if ([node isUserInteractionEnabled]) {
            if ([node containsPoint:location]) {
                if (![node.name  isEqual: @"back"]) {
                    [node runAction:[SKAction playSoundFileNamed:@"menuhit.wav" waitForCompletion:NO]];
                }else{
                    [node runAction:[SKAction playSoundFileNamed:@"menuback.wav" waitForCompletion:NO]];
                }
                [node runAction:[SKAction sequence:@[[SKAction moveByX:50 y:0 duration:0.2],
                                                     [SKAction moveByX:-50 y:0 duration:0]
                                                     ]]];
                [node mouseDown:theEvent];
            }
        }
    }
}
@end

#pragma mark buttons
@implementation TheBigOSUMenuPlay
- (void)mouseDown:(NSEvent *)theEvent{
    [rootNode presentLevel:2];
}
@end
@implementation TheBigOSUMenuExit
- (void)mouseDown:(NSEvent *)theEvent{
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.3],
                                         [SKAction runBlock:^(){[[(AppDelegate *)[[NSApplication sharedApplication] delegate] window] close];}]
                                         ]]];
    
}
@end

@implementation TheBigOSUMenuSolo
- (void)mouseDown:(NSEvent *)theEvent{
    [rootNode presentSoloScene];
}
@end
@implementation TheBigOSUMenuBack

- (id)initWithName:(NSString *)imageName rootNode:(TheBigOSU *)node
{
    self = [super initWithName:imageName rootNode:node];
    if (self) {
        self.name = @"back";
    }
    return self;
}
- (void)mouseDown:(NSEvent *)theEvent{
    [rootNode presentLevel:1];
}
@end

#pragma mark levels
#define itemGap 10
@implementation TheBigOSUMenuLevel1
- (id)initWithRoot:(TheBigOSU *)node
{
    self = [super initWithRoot:node];
    if (self) {
        TheBigOSUMenuPlay *play = [[TheBigOSUMenuPlay alloc] initWithName:@"menu-button-play" rootNode:rootNode];
        [self add:play at:1];
        
        exit = [[TheBigOSUMenuExit alloc] initWithName:@"menu-button-exit" rootNode:rootNode];
        [self add:exit at:4];
        
    }
    return self;
}
- (float)yPositionForItemAtIndex:(int)index
{
    return (itemGap+89)*1.5 - (index-1)* (89+itemGap);
}
@end

@implementation TheBigOSUMenuLevel2
- (id)initWithRoot:(TheBigOSU *)node
{
    self = [super initWithRoot:node];
    if (self) {
        solo = [[TheBigOSUMenuSolo alloc] initWithName:@"menu-button-freeplay" rootNode:rootNode];
        [self add:solo at:1];
        
        back = [[TheBigOSUMenuBack alloc] initWithName:@"menu-button-back" rootNode:rootNode];
        [self add:back at:3];
    }
    return self;
}
- (float)yPositionForItemAtIndex:(int)index
{
    return itemGap+89 - (index-1)* (89+itemGap);
}

@end