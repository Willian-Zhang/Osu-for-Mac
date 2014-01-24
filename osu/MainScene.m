//
//  MainScene.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.08 green:0.46 blue:0.98 alpha:1.0];
        [self initCursorWithSize:size];
    }
    return self;
}
- (void)initCursorWithSize:(CGSize)size{
    NSString *pathToCursorImage = [[NSBundle mainBundle] pathForResource:@"cursor@2x" ofType:@"png" inDirectory:@"osu! by peppy"];
    cursorTexture = [SKTexture textureWithImageNamed:pathToCursorImage];
    //CGPoint location = [theEvent locationInNode:self];
    cursor = [SKSpriteNode spriteNodeWithTexture:cursorTexture];
    cursor.position = CGPointMake(size.width/2, size.height/2);
    cursor.scale =1;
    SKAction *rotationForOnce = [SKAction rotateByAngle:-M_PI duration:10];
    [cursor runAction:[SKAction repeatActionForever:rotationForOnce]];
    
    [self addChild:cursor];
    NSString *pathToCursortailImage = [[NSBundle mainBundle] pathForResource:@"cursortrail@2x" ofType:@"png" inDirectory:@"osu! by peppy"];
    cursortailTexture = [SKTexture textureWithImageNamed:pathToCursortailImage];
    
    lastFrameCursorPosition = CGPointMake(size.width/2, size.height/2);
}

- (void)mouseDown:(NSEvent *)theEvent{
    cursor.position = [theEvent locationInNode:self];
    [self.view.window makeFirstResponder:self.view.scene];
    NSLog(@"%f | %f",cursor.position.x,cursor.position.y);
}
- (void)mouseUp:(NSEvent *)theEvent{
    cursor.position = [theEvent locationInNode:self];
}
- (void)mouseMoved:(NSEvent *)theEvent{
    CGPoint thisFrameCursorPosition = [theEvent locationInNode:self];
    cursor.position = thisFrameCursorPosition;
    
    int tailDensity = 5;
    
    int deltaX = thisFrameCursorPosition.x - lastFrameCursorPosition.x;
    int deltaY = thisFrameCursorPosition.y - lastFrameCursorPosition.y;
    for (int count = 0; count < tailDensity; count++) {
        CGPoint thisCursortailPosition = CGPointMake(thisFrameCursorPosition.x - (deltaX * count / tailDensity), thisFrameCursorPosition.y - (deltaY * count / tailDensity));
        
        SKSpriteNode *cursortail = [SKSpriteNode spriteNodeWithTexture:cursortailTexture];
        cursortail.position = thisCursortailPosition;
        [self addChild:cursortail];
        
        SKAction *fadeToNone = [SKAction fadeAlphaTo:0 duration:0.1];
        SKAction *deleteItself = [SKAction removeFromParent];
        [cursortail runAction:[SKAction sequence:@[fadeToNone, deleteItself]]];
    }
  
    
    lastFrameCursorPosition = thisFrameCursorPosition;
}
- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}
@end
