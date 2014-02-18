//
//  SKSceneWithAdditions.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKSceneWithAdditions.h"
#import "SKMessageNode.h"
#import "AppDelegate.h"
#import "GlobalMusicPlayer.h"
#import "Beatmap.h"

@implementation SKSceneWithAdditions

@synthesize cursor;
@synthesize cursortailTexture;
@synthesize lastFrameCursorPosition;
@synthesize GMP;

@synthesize GMPStartMode;
@synthesize GMPEndMode;



- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initCursor];
        GMP = [(AppDelegate *)[[NSApplication sharedApplication] delegate] globalMusicPlayer];
        [GMP setModeDelegate:self];
        [GMP setEventDelegate:self];
        [[(AppDelegate *)[[NSApplication sharedApplication] delegate] appSupport] setReportDelegate:self];
        contactSet = [[NSMutableSet alloc] init];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

#pragma mark 鼠标指针事件
- (void)initCursor{
    SKTexture *cursorTexture;
    NSString *pathToCursorImage = [[NSBundle mainBundle] pathForResource:@"cursor@2x" ofType:@"png" inDirectory:@"osu! by peppy"];
    cursorTexture = [SKTexture textureWithImageNamed:pathToCursorImage];
    //CGPoint location = [theEvent locationInNode:self];
    cursor = [SKSpriteNode spriteNodeWithTexture:cursorTexture];
    cursor.position = CGPointZero;
    cursor.zPosition = 300;
    cursor.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1];
    cursor.physicsBody.dynamic = YES;
    cursor.physicsBody.categoryBitMask = cursorCategory;
    cursor.physicsBody.contactTestBitMask = buttonCategory;
    //cursor.physicsBody.collisionBitMask = (buttonCategory|hitObjectCategory);
    SKAction *rotationForOnce = [SKAction rotateByAngle:-M_PI duration:10];
    [cursor runAction:[SKAction repeatActionForever:rotationForOnce]];
    [self addChild:cursor];
    
    NSString *pathToCursortailImage = [[NSBundle mainBundle] pathForResource:@"cursortrail@2x" ofType:@"png" inDirectory:@"osu! by peppy"];
    cursortailTexture = [SKTexture textureWithImageNamed:pathToCursortailImage];
    
    lastFrameCursorPosition = CGPointZero;
}
- (void)updateCursor{
    CGPoint thisFrameCursorPosition = [self convertPointFromView:self.view.window.mouseLocationOutsideOfEventStream];
    cursor.position = thisFrameCursorPosition;
    
    int tailDensity = 5;
    
    int deltaX = thisFrameCursorPosition.x - lastFrameCursorPosition.x;
    int deltaY = thisFrameCursorPosition.y - lastFrameCursorPosition.y;
    for (int count = 0; count < tailDensity; count++) {
        CGPoint thisCursortailPosition = CGPointMake(thisFrameCursorPosition.x - (deltaX * count / tailDensity), thisFrameCursorPosition.y - (deltaY * count / tailDensity));
        
        SKSpriteNode *cursortail = [SKSpriteNode spriteNodeWithTexture:cursortailTexture];
        cursortail.position = thisCursortailPosition;
        cursortail.zPosition = 298;
        [self addChild:cursortail];
        
        SKAction *fadeToNone = [SKAction fadeAlphaTo:0 duration:0.1];
        SKAction *deleteItself = [SKAction removeFromParent];
        [cursortail runAction:[SKAction sequence:@[fadeToNone, deleteItself]]];
    }
    lastFrameCursorPosition = thisFrameCursorPosition;
}
#pragma mark 方法
- (void)errorOccurred:(NSString *)errorString{
    [self displayWarning:errorString];
}
- (void)displayWarning:(NSString *)messageString{
    SKMessageNode *message = [[SKMessageNode alloc] initWithWidth:self.size.width];
    [message addMessageMaskWithLines:1];
    [message addMessageLabelWithString:messageString onLine:1];
    [self addChild:message];
    [message playSound];
    [message fadeOut];
}
- (void)displayMessage:(NSString *)messageString{
    [self enumerateChildNodesWithName:@"message" usingBlock:^(SKNode *message,BOOL *stop ){
         [message runAction:[SKAction moveByX:0 y:50 duration:0.2]];
    }];
    SKMessageNode *message = [[SKMessageNode alloc] initWithWidth:self.size.width];
    message.name = @"message";
    [message addMessageMaskWithLines:1];
    [message addMessageLabelWithString:messageString onLine:1];
    [self addChild:message];
    [message fadeOut];
}
- (void)addContact:(SKNode<SKNodeMouseOverEvents> *)node{
    node.physicsBody.contactTestBitMask |= cursorCategory;
    [contactSet addObject:node];
}

@synthesize leftMargin;
@synthesize rightMargin;
@synthesize topMargin;
@synthesize bottomMargin;
- (float)leftMargin{
    float width = self.size.width;
    return width *(self.anchorPoint.x - 1);
}
- (float)rightMargin{
    float width = self.size.width;
    return width *(1 - self.anchorPoint.x);
}
- (float)topMargin{
    float height = self.size.height;
    return height *(1 - self.anchorPoint.y);
}
- (float)bottomMargin{
    float height = self.size.height;
    return height *(self.anchorPoint.y - 1);
}
#pragma mark 统一事件

- (void)leftDown:(NSEvent *)theEvent{
    [self.cursor runAction:[SKAction scaleTo:1.3 duration:0.1]];
}
- (void)leftUp:(NSEvent *)theEvent{
    [self.cursor runAction:[SKAction scaleTo:1 duration:0.1]];
}
- (CGPoint)locationInScene{
    return [self convertPointFromView:self.view.window.mouseLocationOutsideOfEventStream];
}

- (void)resizeMessage{
    SKNode *message = [self childNodeWithName:@"message"];
    if (message != nil) {
        SKNode *messageMask = [message childNodeWithName:@"messageMask"];
        [messageMask runAction:[SKAction resizeToWidth:self.size.width duration:0]];
    }
}
#pragma mark 系统事件
- (void)didBeginContact:(SKPhysicsContact *)contact{
    //NSLog(@"A:%@ B:%@",contact.bodyA.node.className,contact.bodyB.node.className);//uncomment this to debug mouse events
    //B for Cursor
    if (contact.bodyB.node == cursor || contact.bodyA.node == cursor) {
        for (SKNode<SKNodeMouseOverEvents> *node in contactSet) {
            if (node == contact.bodyB.node || node == contact.bodyA.node) {
                if ([node respondsToSelector:@selector(didMouseEnter)]) {
                    if (node.alpha != 0 && node.parent.alpha != 0) {
                        [node didMouseEnter];
                    }
                }
            }
        }
    }
}
- (void)didEndContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.node == cursor || contact.bodyB.node == cursor) {
        for (SKNode<SKNodeMouseOverEvents> *node in contactSet) {
            if (node == contact.bodyA.node || node == contact.bodyB.node ) {
                if ([node respondsToSelector:@selector(didMouseExit)]) {
                    [node didMouseExit];
                }
            }
        }
    }
}

- (void)didChangeSize:(CGSize)oldSize{
    [self resizeMessage];
}
- (void)keyDown:(NSEvent *)theEvent{
    if (theEvent.keyCode == 6) {
        [self leftDown:theEvent];
    }else if (theEvent.keyCode == 7){
        [self leftDown:theEvent];
    }
}
- (void)keyUp:(NSEvent *)theEvent{
    if (theEvent.keyCode == 6) {
        [self leftUp:theEvent];
    }else if (theEvent.keyCode == 7){
        [self leftUp:theEvent];
    }
}
- (void)mouseDown:(NSEvent *)theEvent{
    [self leftDown:theEvent];
    CGPoint location =  [theEvent locationInNode:self];
    for (SKNode *node in self.children) {
        if ([node isUserInteractionEnabled]) {
            if ([node containsPoint:location]) {
                [node mouseDown:theEvent];
            }
        }
    }
}
- (void)mouseUp:(NSEvent *)theEvent{
    [self.cursor runAction:[SKAction scaleTo:1 duration:0.1]];
    
    CGPoint location =  [theEvent locationInNode:self];
    for (SKNode *node in self.children) {
        if ([node isUserInteractionEnabled]) {
            if ([node containsPoint:location]) {
                [node mouseUp:theEvent];
            }
        }
    }
}


- (void)didSimulatePhysics{
    [self updateCursor];
}

@end
