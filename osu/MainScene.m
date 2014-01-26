//
//  MainScene.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}
static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        size = size;
        self.backgroundColor = [SKColor colorWithRed:0.08 green:0.46 blue:0.98 alpha:1.0];
        [self initCursor];
        [self initTheBigOSU];
        [self initBackground];
    }
    return self;
}
- (void)initBackground{
    backgroundCircles = [[SKNode alloc] init];
    SKNode *backgroundCircleGroup = [self childNodeWithName:@"backgroundCircles"];
    if (backgroundCircleGroup != nil) {
        backgroundCircles = backgroundCircleGroup;
    }else{
        backgroundCircles.name = @"backgroundCircles";
    }
    srand((unsigned)time(0));
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
    int maxBackgroundCircleNumber = 16;
    for (int circleCount = 0; circleCount< (int)(skRand(maxBackgroundCircleNumber/2,maxBackgroundCircleNumber)); circleCount++) {
        SKShapeNode *aCircle = [[SKShapeNode alloc] init];
        CGMutablePathRef theCirclePath = CGPathCreateMutable();
        CGPathAddArc(theCirclePath, NULL, 0, 0, skRand(screenLimitScaleWidth * 0.01,screenLimitScaleWidth * 0.3), 0, M_PI * 2, YES);
        aCircle.fillColor = [SKColor whiteColor];
        aCircle.lineWidth = 0;
        aCircle.alpha = 0.1;
        aCircle.path = theCirclePath;
        aCircle.zPosition = 10;
        aCircle.position = CGPointMake(skRand(0, self.size.width), skRand(0, self.size.height));
        [backgroundCircles addChild:aCircle];
    }
    if (backgroundCircleGroup == nil) {
        [self addChild:backgroundCircles];
    }
}
- (void)resizeBackground{
    SKNode *backgroundCircleGroup = [self childNodeWithName:@"backgroundCircles"];
    if (backgroundCircleGroup != nil) {
        [backgroundCircleGroup removeAllChildren];
        [self initBackground];
    }
}
- (void)initCursor{
    NSString *pathToCursorImage = [[NSBundle mainBundle] pathForResource:@"cursor@2x" ofType:@"png" inDirectory:@"osu! by peppy"];
    cursorTexture = [SKTexture textureWithImageNamed:pathToCursorImage];
    //CGPoint location = [theEvent locationInNode:self];
    cursor = [SKSpriteNode spriteNodeWithTexture:cursorTexture];
    cursor.position = [self centerPointForSize:self.size];
    cursor.zPosition = 300;
    SKAction *rotationForOnce = [SKAction rotateByAngle:-M_PI duration:10];
    [cursor runAction:[SKAction repeatActionForever:rotationForOnce]];
    [self addChild:cursor];
    
    NSString *pathToCursortailImage = [[NSBundle mainBundle] pathForResource:@"cursortrail@2x" ofType:@"png" inDirectory:@"osu! by peppy"];
    cursortailTexture = [SKTexture textureWithImageNamed:pathToCursortailImage];
    
    lastFrameCursorPosition = [self centerPointForSize:self.size];
}
- (void)initTheBigOSU{
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];

    float scaleDuration = 0.3;
    float theBigOSUSize = screenLimitScaleWidth * 7/9;
    
    SKTexture *theBigOSUTexture = [SKTexture textureWithImageNamed:@"theBigOSU"];
    SKSpriteNode *theBigOSU = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture size:CGSizeMake(theBigOSUSize, theBigOSUSize)];
    theBigOSU.zPosition = 20;
    theBigOSU.position = CGPointMake(self.size.width/2, self.size.height * (0.5 + 0.04266) );
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
        float theBigOSUSize = screenLimitScaleWidth * 7/9;
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
- (void)resizeTheBigOSU:(CGSize)oldSize{
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
    float theBigOSUSize = screenLimitScaleWidth * 7 / 9;
    
    SKNode *theBigOSU = [self childNodeWithName:@"theBigOSU"];
    theBigOSU.position = CGPointMake(self.size.width/2, self.size.height * (0.5 + 0.04266) );
    [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0]];
}
- (void)didChangeSize:(CGSize)oldSize{
    sceneSize = self.scene.size;
    [self resizeTheBigOSU:oldSize];
    [self resizeBackground];
}
- (void)mouseDown:(NSEvent *)theEvent{
    cursor.position = [theEvent locationInNode:self];
    [self.view.window makeFirstResponder:self.view.scene];
    //NSLog(@"%f | %f",cursor.position.x,cursor.position.y);
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
        cursortail.zPosition = 298;
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
