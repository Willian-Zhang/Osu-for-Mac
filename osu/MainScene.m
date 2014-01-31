//
//  MainScene.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "MainScene.h"
#import "SKMessageNode.h"


@implementation MainScene

#pragma mark 方法

- (void)displayFirstRunSettingsWithCompletion:(void (^)(NSInteger result))block{
    SKMessageNode *message = [[SKMessageNode alloc] initWithWidth:self.size.width];

    
    [message addMessageMaskWithLines:1];
    [message addMessageLabelWithString:NSLocalizedString(@"First time? Follow the guide please~", @"First time Notice") onLine:1];

    [self addChild:message];
    [message fadeOut];
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:1],
                                         [SKAction runBlock:^(void){
        firstRunController = [[FirstRunWindowController alloc] initWithWindowNibName:@"FirstRunWindow"];
        [firstRunController showWindow:self];
        [firstRunController showRelativeToRect:message.frame ofView:self.view preferredEdge:NSMinYEdge completion:block];
                                                                    }]
                                         ]]];
}
- (void)displayMessage:(NSString *)messageString{
    SKMessageNode *message = [[SKMessageNode alloc] initWithWidth:self.size.width];
    [message addMessageMaskWithLines:1];
    [message addMessageLabelWithString:messageString onLine:1];
    [self addChild:message];
    [message fadeOut];
}
#pragma mark 初始化
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        sceneSize = size;
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
        self.backgroundColor = [SKColor colorWithRed:0.08 green:0.46 blue:0.98 alpha:1.0];
        
        theBigOSUFraction = (6.0 / 9.0);
        theBigOSUMouseHoverFraction = 1;
        [self initCursor];
        [self initTheBigOSU];
        [self initBackground];
        
        
    }
    return self;
}
- (void)initBackground{
    
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MainStar" ofType:@"sks"]];
    [stars setParticleTexture:[SKTexture textureWithImageNamed:@"star2"]];
    stars.particlePositionRange = CGVectorMake(self.size.width, self.size.height);
    stars.name = @"backgroundStars";
    [self addChild:stars];
    
    SKEmitterNode *circles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MainCircle" ofType:@"sks"]];
    [circles setParticleTexture:[SKTexture textureWithImageNamed:@"main-background-circle"]];
    circles.particlePositionRange = CGVectorMake(self.size.width, self.size.height);
    circles.name = @"backgroundCircles";
    [self addChild:circles];
    
//    SKNode *backgroundNodes = [self childNodeWithName:@"backgroundNodes"];
//    
//    NSArray *backgroundNodesArray = [backgroundNodes children];
//    
//    if ([backgroundNodesArray count] == 0) {
//        if (backgroundNodes == nil) {
//            backgroundNodes = [[SKNode alloc] init];
//            [self addChild:backgroundNodes];
//        }
//        backgroundNodes.name = @"backgroundNodes";
//        
//        
//    }
    

}

- (void)initCursor{
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
- (void)initTheBigOSU{
    
    
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];

    float scaleDuration = 1;
    float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
    
    SKTexture *theBigOSUTexture = [SKTexture textureWithImageNamed:@"theBigOSU"];
    SKSpriteNode *theBigOSU = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture size:CGSizeMake(theBigOSUSize, theBigOSUSize)];
    theBigOSU.zPosition = 20;
    theBigOSU.position = CGPointMake(0, self.size.height * 0.04266 );
    theBigOSU.name = @"theBigOSU";
    
    SKAction *theShadowAction = [SKAction sequence:@[
                     [SKAction group:@[
                                       [SKAction scaleTo:1.04 duration:scaleDuration],
                                       [SKAction fadeOutWithDuration:scaleDuration]
                                       ]],
                     [SKAction removeFromParent]
                     ]];
    SKAction *createShadow =[SKAction runBlock:^(void){
        float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
        float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
        SKSpriteNode *theBigOSUShadow = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture size:CGSizeMake(theBigOSUSize, theBigOSUSize)];
        float originalShadowAlpha = 0.6;
        theBigOSUShadow.alpha = originalShadowAlpha;
        theBigOSUShadow.zPosition = 21;
        theBigOSUShadow.position = theBigOSU.position;
        theBigOSUShadow.name = @"theBigOSUShadow";
        [self addChild:theBigOSUShadow];
        [theBigOSUShadow runAction:theShadowAction];
    }];
    
    SKAction *theWaveAction = [SKAction sequence:@[
                    [SKAction group:@[
                                    [SKAction scaleTo:1.3 duration:1],
                                    [SKAction fadeOutWithDuration:1]
                                    ]],
                    [SKAction removeFromParent]
                    ]];
    SKAction *createWave = [SKAction runBlock:^(void){
        float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
        float theBigOSUSize = screenLimitScaleWidth * 7/9;
        SKShapeNode *theBigWave = [[SKShapeNode alloc] init];
        CGMutablePathRef theBigWavePath = CGPathCreateMutable();
        CGPathAddArc(theBigWavePath, NULL, 0, 0, theBigOSUSize/2, 0, M_PI * 2, YES);
        theBigWave.fillColor = [SKColor whiteColor];
        
        theBigWave.lineWidth = 0;
        theBigWave.alpha = 0.3;
        theBigWave.path = theBigWavePath;
        theBigWave.zPosition = 15;
        theBigWave.position = theBigOSU.position;
        theBigWave.name = @"theBigWave";
        [self addChild:theBigWave];
        [theBigWave runAction:theWaveAction];
    }];
    SKAction *theOSUAction =[SKAction repeatActionForever:[SKAction sequence:@[
                [SKAction scaleTo:0.96  duration:scaleDuration],
                [SKAction group:@[
                                   [SKAction scaleTo:1 duration:0],
                                   createShadow,
                                   createWave
                                   ]]
                 ]] ];
    [self addChild:theBigOSU];
  
    [theBigOSU runAction:theOSUAction];
}
#pragma mark 响应事件 - Resize
- (void)didChangeSize:(CGSize)oldSize{
    sceneSize = self.scene.size;
    [self resizeTheBigOSU:oldSize];
    [self resizeBackground];
    [self resizeMessage];
}
- (void)resizeMessage{
    SKNode *message = [self childNodeWithName:@"message"];
    if (message != nil) {
        SKNode *messageMask = [message childNodeWithName:@"messageMask"];
        [messageMask runAction:[SKAction resizeToWidth:self.size.width duration:0]];
    }
}
- (void)resizeBackground{
    SKEmitterNode *circles =(SKEmitterNode *)([self childNodeWithName:@"backgroundCircles"]);
    SKEmitterNode *stars = (SKEmitterNode *)([self childNodeWithName:@"backgroundStars"]);
    circles.particlePositionRange = CGVectorMake(self.size.width, self.size.height);
    stars.particlePositionRange = CGVectorMake(self.size.width, self.size.height);
//    SKNode *backgroundNodesNode = [self childNodeWithName:@"backgroundNodes"];
//    if (backgroundNodesNode != nil) {
//        [backgroundNodesNode removeAllChildren];
//        [self initBackground];
//    }
}
- (void)resizeTheBigOSU:(CGSize)oldSize{
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
    float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
    
    SKNode *theBigOSU = [self childNodeWithName:@"theBigOSU"];
    [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0]];
}
#pragma mark 响应事件 - 主要
- (void)showMainMenu{
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
    float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
    
    SKNode *theBigOSU = [self childNodeWithName:@"theBigOSU"];
    
    [theBigOSU runAction:[SKAction group:@[
                                           [SKAction moveToX:-theBigOSUSize*0.2 duration:0.4],
                                           [SKAction playSoundFileNamed:@"menuhit.wav" waitForCompletion:NO]
                                           ]]];
}
- (void)pressed:(NSPoint )position{
    [cursor runAction:[SKAction scaleTo:1.3 duration:0.1]];
    SKNode *theBigOSU = [self childNodeWithName:@"theBigOSU"];
    if ([theBigOSU containsPoint:position]) {
        [self showMainMenu];
    }
}
- (void)mouseStyleUpdate{
    CGPoint thisFrameCursorPosition = [self convertPointFromView:self.view.window.mouseLocationOutsideOfEventStream];
    cursor.position = thisFrameCursorPosition;
    
    int tailDensity = 4;
    
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
- (void)hoverDetect{
    CGPoint thisFrameCursorPosition = [self convertPointFromView:self.view.window.mouseLocationOutsideOfEventStream];
    SKNode *theBigOSU = [self childNodeWithName:@"theBigOSU"];
    BOOL currentState = [theBigOSU containsPoint:thisFrameCursorPosition];
    if (currentState == YES & theBigOSUMouseHoverFraction == 1) {
        theBigOSUMouseHoverFraction = 1.1;
        float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
        float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
        [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0.1]];
    }else if(currentState == NO & theBigOSUMouseHoverFraction > 1.02){
        theBigOSUMouseHoverFraction = 1;
        float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
        float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
        [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0.1]];
    }
}
#pragma mark 响应事件 - 系统
- (void)mouseDown:(NSEvent *)theEvent{
    //[self.view.window makeFirstResponder:self.view.scene];
    [self pressed:[theEvent locationInNode:self]];
}
- (void)mouseUp:(NSEvent *)theEvent{

    [cursor runAction:[SKAction scaleTo:1 duration:0.1]];
}
- (void)mouseDragged:(NSEvent *)theEvent{

    
}
- (void)mouseMoved:(NSEvent *)theEvent{

    

}
- (void)update:(CFTimeInterval)currentTime {
    [self mouseStyleUpdate];
    [self hoverDetect];
    /* Called before each frame is rendered */
}
#pragma mark functions
- (float)limitScaleWidthForSize:(CGSize )size{
    float limitScaleWidth = size.height;
    if (limitScaleWidth > size.width) {
        limitScaleWidth = size.width;
    }
    return limitScaleWidth;
}
- (CGPoint)centerPointForSize:(CGSize )size{
    CGPoint point = CGPointMake(size.width/2, size.height/2);
    return point;
}



@end
