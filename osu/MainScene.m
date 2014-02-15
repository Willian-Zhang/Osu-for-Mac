//
//  MainScene.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "MainScene.h"

#import "AppDelegate.h"
#import "ApplicationSupport.h"

#import "DBTimingPoint.h"
#import "Beatmap.h"

#import "GlobalMusicPlayer.h"
#import "SKMusicPlayerControllerNode.h"

#import "SKMessageNode.h"
#import "SingleSongSelectScene.h"
#import "SettingsDealer.h"

@implementation MainScene



#pragma mark 初始化
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
        self.backgroundColor = [SKColor colorWithRed:0.08 green:0.46 blue:0.98 alpha:1.0];
        menuLevel = 0;
        
        theBigOSUFraction = (6.0 / 9.0);
        theBigOSUMouseHoverFraction = 1;

        [self initTheBigOSU];
        [self initBackground];
        [self initMusicController];
    }
    return self;
}
// called when inited
- (void)willMoveFromView:(SKView *)view{
    NSLog(@"%@",[view.scene.class description]);
}
- (void)didMoveToView:(SKView *)view{
    [self setGMPStartMode:GlobalMusicPlayerStartModeFromBegin];
    [self setGMPEndMode:GlobalMusicPlayerEndModeRandom];
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
}
- (void)initMusicController{
    musicControllerNode = [[SKMusicPlayerControllerNode alloc] initWithScene:self];
    musicControllerNode.zPosition = 50;
    musicControllerNode.position = CGPointMake([super rightMargin], [super topMargin]);
    [self addChild:musicControllerNode];
}

- (void)initTheBigOSU{
    
    
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];

    float theBigOSUSpeed = 1;
    float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
    
    SKTexture *theBigOSUTexture = [SKTexture textureWithImageNamed:@"theBigOSU"];
    theBigOSU = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture size:CGSizeMake(theBigOSUSize, theBigOSUSize)];
    theBigOSU.zPosition = 20;
    theBigOSU.position = CGPointMake(0, self.size.height * 0.04266 );//移高偏移
    
    SKAction *theShadowAction = [SKAction sequence:@[
                     [SKAction scaleTo:1.01 duration:0],
                     [SKAction group:@[
                                       [SKAction scaleTo:1.05 duration:theBigOSUSpeed],
                                       [SKAction fadeOutWithDuration:theBigOSUSpeed]
                                       ]],
                     [SKAction removeFromParent]
                     ]];
   SKAction *createShadow =[SKAction runBlock:^(void){
        float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
        float theBigOSUSize = screenLimitScaleWidth *  theBigOSUFraction * theBigOSUMouseHoverFraction;
        theBigOSUShadow = [SKSpriteNode spriteNodeWithTexture:theBigOSUTexture size:CGSizeMake(theBigOSUSize, theBigOSUSize)];
        float originalShadowAlpha = 0.6;
        theBigOSUShadow.alpha = originalShadowAlpha;
        theBigOSUShadow.zPosition = 10;
        theBigOSUShadow.position = CGPointZero;//theBigOSU.position;
        [theBigOSU addChild:theBigOSUShadow];
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
        float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
        SKShapeNode *theBigWave = [[SKShapeNode alloc] init];
        CGMutablePathRef theBigWavePath = CGPathCreateMutable();
        CGPathAddArc(theBigWavePath, NULL, 0, 0, theBigOSUSize/2, 0, M_PI * 2, YES);
        theBigWave.fillColor = [SKColor whiteColor];
        
        theBigWave.lineWidth = 0;
        theBigWave.alpha = 0.3;
        theBigWave.zPosition = 5;
        theBigWave.position = theBigOSU.position;
        //theBigWave.name = @"theBigWave";
        theBigWave.path = theBigWavePath;
        
        [self addChild:theBigWave];
        CGPathRelease(theBigWavePath);
        
        [theBigWave runAction:theWaveAction];
    }];
    
    theBigOSUAction =[SKAction repeatActionForever:[SKAction sequence:@[
                [SKAction scaleTo:0.96  duration:theBigOSUSpeed],
                [SKAction group:@[
                                   [SKAction scaleTo:1 duration:0],
                                   createShadow,
                                   createWave
                                   ]]
                 ]] ];
    [self addChild:theBigOSU];
    [theBigOSU runAction:theBigOSUAction];
}
#pragma mark 方法
- (void)initBGM{
    ApplicationSupport *appSupport = [(AppDelegate *)[[NSApplication sharedApplication] delegate] appSupport];
    SettingsDealer *settings = [[SettingsDealer alloc] init];
    if (![settings firstConfigured]) {
        [self displayWarning:NSLocalizedString(@"You have to finish the Settings first!", @"You have to finish the Settings first!")];
    }else if (![appSupport isAllBeatmapsReady]) {
            //[self displayWarning:NSLocalizedString(@"Go to \"Play → Solo\" to update database", @"Database needs update")];
    }else{
        [self setGMPStartMode:GlobalMusicPlayerStartModeFromClimax];
        [super.GMP playRandom];
        [self setGMPStartMode:GlobalMusicPlayerStartModeFromBegin];
        [self synchronizePopingWithRythemOf:super.GMP.mapPlaying];
        [musicControllerNode updateNowPlaying:super.GMP.mapPlaying.title];
    }
}
- (void)synchronizePopingWithRythemOf:(Beatmap *)beatmap{
    [theBigOSU removeAllActions];
    float theBigOSUSpeed = super.GMP.currentBps;
    float nextTiming = [super.GMP timeIntervalToNextBeat];
    [theBigOSU runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:nextTiming],
                                              theBigOSUAction
                                              ]]
     ];
    theBigOSU.speed = theBigOSUSpeed;
    //NSLog(@"Speed: %f",theBigOSU.speed);
    
    SKEmitterNode *stars = (SKEmitterNode *)([self childNodeWithName:@"backgroundStars"]);
    stars.particleBirthRate = theBigOSUSpeed * 10;

}
- (void)peacePoping{
    [theBigOSU runAction:[SKAction speedTo:1 duration:0]];
    SKEmitterNode *stars = (SKEmitterNode *)([self childNodeWithName:@"backgroundStars"]);
    stars.particleBirthRate = 2;

}
- (void)displayFirstRun{
    [self displayFirstRunSettingsWithCompletion:^(NSInteger result){
        if (result == FirstRunConfigureFailed){
            [self displayWarning:NSLocalizedString(@"You have to finish the Settings first!", @"First Run Setting Required Message")];
            return ;
        }else if (result == FirstRunConfigureSucceed){
            //here
        }
    }];
}
- (void)displayFirstRunSettingsWithCompletion:(void (^)(NSInteger result))block{
    [self displayMessage:NSLocalizedString(@"First time? Follow the guide please~", @"First time Notice")];

    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:1],
                                         [SKAction runBlock:^(void){
        firstRunController = [[FirstRunWindowController alloc] initWithWindowNibName:@"FirstRunWindow"];
        [firstRunController showWindow:self];
        [firstRunController showRelativeToRect:CGRectMake(self.view.frame.origin.x,
                                                          self.view.frame.origin.y - self.view.frame.size.height + 15,
                                                          self.view.frame.size.width,30)
                                        ofView:self.view preferredEdge:NSMinYEdge completion:block];
    }]
                                         ]]];
}
#pragma mark 响应事件 - Resize
- (void)didChangeSize:(CGSize)oldSize{
    [super didChangeSize:oldSize];
    [self resizeTheBigOSU:oldSize];
    [self resizeBackground];
    [self resizeMusicController];
}
- (void)resizeMusicController{
    musicControllerNode.position = CGPointMake([super rightMargin], [super topMargin]);
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
    
    [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0]];
}
#pragma mark 响应事件 - 主要
- (void)GMPwillEndPlaying:(Beatmap *)beatmap{
    [self peacePoping];
}
- (void)GMPdidEndPlayingAndPlays:(Beatmap *)beatmap{
    if (![beatmap indexOfKeyTimingPointsAt:super.GMP.currentTime] == 0) {
        [self synchronizePopingWithRythemOf:beatmap];
    }
    [musicControllerNode updateNowPlaying:beatmap.title];
}

- (void)showMainMenu{
    float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
    float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
    
    
    SKAction *moveLeft = [SKAction moveToX:-theBigOSUSize*0.2 duration:0.2 ];
    moveLeft.timingMode =SKActionTimingEaseOut;
    [theBigOSU runAction:[SKAction group:@[
                                           moveLeft,
                                           [SKAction playSoundFileNamed:@"menuhit.wav" waitForCompletion:NO],
                                           [SKAction sequence:@[
                                                                [SKAction waitForDuration:1],
                                                                [SKAction runBlock:^(void){
        if ([[[SettingsDealer alloc] init] firstConfigured]) {
            SingleSongSelectScene *soloScene = [SingleSongSelectScene sceneWithSize:self.view.window.frame.size];
            [self.view presentScene:soloScene transition:[SKTransition fadeWithColor:[NSColor blackColor] duration:0.5]];
        }
    }]]]
                                           ]]];
}
- (void)leftDown:(NSEvent *)theEvent{
    [super leftDown:theEvent];

    if ([theBigOSU containsPoint:[super locationInScene]]) {
        [self showMainMenu];
    }
}


- (void)overDetect{
    CGPoint thisFrameCursorPosition = [super locationInScene];
    BOOL currentState = [theBigOSU containsPoint:thisFrameCursorPosition];
    if (currentState == YES & theBigOSUMouseHoverFraction == 1) {
        theBigOSUMouseHoverFraction = 1.1;
        float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
        float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
        [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0.4]];
    }else if(currentState == NO & theBigOSUMouseHoverFraction > 1.02){
        theBigOSUMouseHoverFraction = 1;
        float screenLimitScaleWidth = [self limitScaleWidthForSize:self.size];
        float theBigOSUSize = screenLimitScaleWidth * theBigOSUFraction * theBigOSUMouseHoverFraction;
        [theBigOSU runAction:[SKAction resizeToWidth:theBigOSUSize height:theBigOSUSize duration:0.4]];
    }
}
#pragma mark 响应事件 - 系统
- (void)update:(NSTimeInterval)currentTime{
    [self overDetect];
}


#pragma mark functions
- (float)limitScaleWidthForSize:(CGSize )size{
    float limitScaleWidth = size.height;
    if (limitScaleWidth > size.width) {
        limitScaleWidth = size.width;
    }
    return limitScaleWidth;
}

@end
