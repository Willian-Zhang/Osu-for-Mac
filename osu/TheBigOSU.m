//
//  TheBigOSU.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-14.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#define buttonFraction (2.0/3.0)
#import "TheBigOSU.h"
#import "TheBigOSUButton.h"
#import "TheBigOSUShadow.h"
#import "TheBigOSUShockwave.h"
#import "TheBigOSUMenuButtons.h"

#import "SKSceneWithAdditions.h"

#import "GlobalMusicPlayer.h"
#import "Beatmap.h"
#import "DBTimingPoint.h"

@implementation TheBigOSU
@synthesize frame = _frame;

- (id)initWithScene:(SKSceneWithAdditions *)scene
{
    self = [super init];
    if (self) {
        menuLevel = 0;
        callerScene= scene;
        GMP = [GlobalMusicPlayer getGMP];
        _frame = scene.frame;
        self.userInteractionEnabled = YES;
        [self initButton];
        [self initPoping];
        [self initShadow];
        [self initShockwave];
        [self initMenuButtons];
    }
    return self;
}
- (void)initMenuButtons{
    menuButtons = [[TheBigOSUMenuButtons alloc] init];
    menuButtons.alpha = 0;
    menuButtons.zPosition = 10;
    [self addChild:menuButtons];
    [menuButtons setScale:(button.calculateAccumulatedFrame.size.height/386)*0.8];
    [menuButtons setPosition:CGPointMake(0, button.position.y)];
}
- (void)initButton{
    float screenLimitScaleWidth = [self limitScaleWidthForSize:_frame.size];
    float theBigOSUSize = screenLimitScaleWidth * buttonFraction * 1;
    button = [[TheBigOSUButton alloc] initWithSize:CGSizeMake(theBigOSUSize, theBigOSUSize)];
    button.zPosition = 20;
    button.position = CGPointMake(0, _frame.size.height * 0.04266 );//移高偏移
    [self addChild:button];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:button.calculateAccumulatedFrame.size.width/2];
    button.physicsBody = body;
    button.physicsBody.dynamic = NO;
    button.physicsBody.categoryBitMask = buttonCategory;
    [callerScene addContact:button];
}
- (void)initShadow{
    float theBigOSUSize = button.calculateAccumulatedFrame.size.width;
    shadow = [[TheBigOSUShadow alloc] initWithSize:CGSizeMake(theBigOSUSize, theBigOSUSize)];
    shadow.zPosition = 30;
    shadow.position = button.position;
    [self addChild:shadow];
    [shadow runAction];
}
- (void)initShockwave{
    float theBigOSUSize = button.calculateAccumulatedFrame.size.width;
    shockwave = [[TheBigOSUShockwave alloc] initWithSize:CGSizeMake(theBigOSUSize, theBigOSUSize)];
    shockwave.zPosition = 5;
    shockwave.position = button.position;
    [self addChild:shockwave];
    [shockwave runAction];
}
- (void)initPoping{
    SKAction *popShadow = [SKAction runBlock:^(void){
        float theBigOSUSize = button.calculateAccumulatedFrame.size.width;
        [shadow popWithSize:CGSizeMake(theBigOSUSize, theBigOSUSize)];
        shadow.position = button.position;
    }];
    SKAction *createShockwave   = [SKAction runBlock:^(void){
        float theBigOSUSize = button.calculateAccumulatedFrame.size.width;
        [shockwave setPosition:CGPointMake(0, button.position.y)];
        [shockwave popWithFrame:CGRectMake(button.position.x, 0, theBigOSUSize, theBigOSUSize)];
    }];
    pop = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction scaleTo:0.96  duration:1],
                                                             [SKAction group:@[[SKAction scaleTo:1 duration:0], popShadow, createShockwave]]
                                                             ]]];
    [button runAction:pop];
}

#pragma mark calls

- (void)resizeTo:(NSRect)frame{
    _frame = frame;
    float screenLimitScaleWidth = [self limitScaleWidthForSize:_frame.size];
    float theBigOSUSize = screenLimitScaleWidth * buttonFraction * button.hoverFraction;
    [button resizeTo:theBigOSUSize];
    button.position = CGPointMake(0, _frame.size.height * 0.04266 );//移高偏移
    
    [menuButtons runAction:[SKAction scaleTo:(theBigOSUSize/386)*0.8 duration:0]];
    [menuButtons runAction:[SKAction moveToY:button.position.y duration:0]];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:button.calculateAccumulatedFrame.size.width/2];
    button.physicsBody = body;
    button.physicsBody.dynamic = NO;
    button.physicsBody.categoryBitMask = buttonCategory;
}
- (void)synchronizePopingTo:(Beatmap *)beatmap{
    [button removeAllActions];
    //[shadow removeAllActions];
    float theBigOSUSpeed = GMP.currentBps;
    button.speed = theBigOSUSpeed;
    shadow.speed = theBigOSUSpeed;
    float nextTiming = [GMP timeIntervalToNextBeat];
    [button runAction:[SKAction sequence:@[[SKAction waitForDuration:nextTiming],pop]]];
    //[shadow runAction:[SKAction sequence:@[[SKAction waitForDuration:nextTiming],[SKAction runBlock:^(){[shadow runAction];}]]]];
}
#pragma mark functions
- (float)limitScaleWidthForSize:(CGSize )size{
    float limitScaleWidth = size.height;
    if (limitScaleWidth > size.width) {
        limitScaleWidth = size.width;
    }
    return limitScaleWidth;
}

- (void)mouseDown:(NSEvent *)theEvent{
    CGPoint location =  [theEvent locationInNode:self];
    for (SKNode *node in self.children) {
        if ([node isUserInteractionEnabled]) {
            if ([node containsPoint:location]) {
                [node mouseDown:theEvent];
                if (node == button) {
                    [self bigButtonPressed];
                }
            }
        }
    }
}
- (void)bigButtonPressed{
    float screenLimitScaleWidth = [self limitScaleWidthForSize:callerScene.size];
    float theBigOSUSize = screenLimitScaleWidth * buttonFraction * button.hoverFraction;
    
    
    SKAction *moveLeft = [SKAction moveToX:-theBigOSUSize*0.2 duration:0.2];
    moveLeft.timingMode =SKActionTimingEaseOut;
    [button runAction:[SKAction group:@[moveLeft,[SKAction playSoundFileNamed:@"menuhit.wav" waitForCompletion:NO],
                                        [SKAction runBlock:^(){
        if (menuLevel<2) {
            menuLevel++;
            [self showMenu];
        }
    }]
                                        ]]];

}
- (void)showMenu{

    [button removeActionForKey:@"moveBackTheBigOSU"];
    [menuButtons removeAllActions];
    
    [menuButtons runAction:[SKAction group:@[[SKAction fadeAlphaTo:1 duration:0.2],
                                             [SKAction moveToX:button.calculateAccumulatedFrame.size.height*0.3 duration:0.2]
                                             ]]
     ];
    if(menuLevel == 1){
        
    }
    //        if ([[[SettingsDealer alloc] init] firstConfigured]) {
    //            SingleSongSelectScene *soloScene = [SingleSongSelectScene sceneWithSize:self.view.window.frame.size];
    //            [self.view presentScene:soloScene transition:[SKTransition fadeWithColor:[NSColor blackColor] duration:0.5]];
    //        }
    
    [menuButtons runAction:[SKAction sequence:@[[SKAction waitForDuration:5],
                                                [SKAction group:@[[SKAction moveToX:0 duration:1],
                                                                  [SKAction fadeAlphaTo:0 duration:0.5],
                                                                  [SKAction runBlock:^(){
        SKAction *moveBack =[SKAction moveToX:0 duration:GMP.currentBps];
        [button runAction:moveBack withKey:@"moveBackTheBigOSU"];
    }]
                                                                  ]],
                                                [SKAction runBlock:^(){
        menuLevel = 0;
    }]

                                                ]]];
}
@end
