//
//  SKSceneWithAdditions.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKSceneWithAdditions.h"
#import "SKMessageNode.h"

@implementation SKSceneWithAdditions

@synthesize cursor;
@synthesize cursortailTexture;
@synthesize lastFrameCursorPosition;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initCursor];
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
- (void)displayMessage:(NSString *)messageString{
    SKMessageNode *message = [[SKMessageNode alloc] initWithWidth:self.size.width];
    [message addMessageMaskWithLines:1];
    [message addMessageLabelWithString:messageString onLine:1];
    [self addChild:message];
    [message fadeOut];
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
}
- (void)mouseUp:(NSEvent *)theEvent{
    [self.cursor runAction:[SKAction scaleTo:1 duration:0.1]];
}

- (void)didSimulatePhysics{
    [self updateCursor];
}

@end
