//
//  TheBigOSU.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-14.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#define buttonFraction (2.0/3.0)
#define buttonScale 522

#import "TheBigOSU.h"
#import "TheBigOSUButton.h"
#import "TheBigOSUShadow.h"
#import "TheBigOSUShockwave.h"
#import "TheBigOSUMenu.h"

#import "SKSceneWithAdditions.h"
#import "SettingsDealer.h"
#import "SingleSongSelectScene.h"

#import "GlobalMusicPlayer.h"
#import "Beatmap.h"
#import "DBTimingPoint.h"

@implementation TheBigOSU
@synthesize frame = _frame;
@synthesize callerScene;

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
        [self setScale:([self limitScaleWidthForSize:scene.frame.size]/buttonScale)*buttonFraction];
    }
    return self;
}
- (void)initMenuButtons{
    menuLevel1 = [[TheBigOSUMenuLevel1 alloc] initWithRoot:self];
    menuLevel1.alpha = 0;
    menuLevel1.zPosition = 10;
    [self addChild:menuLevel1];
    [menuLevel1 setPosition:CGPointMake(0, button.position.y)];
    
    menuLevel2 = [[TheBigOSUMenuLevel2 alloc] initWithRoot:self];
    menuLevel2.alpha = 0;
    menuLevel2.zPosition = 9;
    [self addChild:menuLevel2];
    [menuLevel2 setPosition:CGPointMake(0, button.position.y)];
}
- (void)initButton{
    button = [[TheBigOSUButton alloc] init];
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
    shadow = [[TheBigOSUShadow alloc] init];
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
        //[shockwave setPosition:CGPointMake(0, button.position.y)];
        [shockwave popWithFrame:CGRectMake(button.position.x, 0, theBigOSUSize, theBigOSUSize)];
    }];
    pop = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction scaleTo:0.96  duration:1],
                                                             [SKAction group:@[[SKAction scaleTo:1 duration:0], popShadow, createShockwave]]
                                                             ]]];
    [button runAction:pop];
}

#pragma mark calls

- (void)resizeTo:(NSRect)frame{
    [self setScale:([self limitScaleWidthForSize:frame.size]/522)*buttonFraction];
    [self resizeButton];
}
- (void)resizeButton{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:button.calculateAccumulatedFrame.size.width/2];
    button.physicsBody = body;
    button.physicsBody.dynamic = NO;
    button.physicsBody.categoryBitMask = buttonCategory;
}
- (void)synchronizePopingTo:(Beatmap *)beatmap{
    [button removeAllActions];
    
    float theBigOSUSpeed = GMP.currentBps;
    button.speed = theBigOSUSpeed;
    shadow.speed = theBigOSUSpeed;
    float nextTiming = [GMP timeIntervalToNextBeat];
    [button runAction:[SKAction sequence:@[[SKAction waitForDuration:nextTiming],pop]]];
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
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"zPosition" ascending:NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSArray *sortedNodes  = [[self nodesAtPoint:location]  sortedArrayUsingDescriptors:sortArray];
    
    for (SKNode *node in sortedNodes) {
        if ([node isUserInteractionEnabled]) {
            if (node.alpha != 0) {
                [node mouseDown:theEvent];
                if (node == button) {
                    [self bigButtonPressed];
                }
                return;
            }
        }
    }
}
- (void)bigButtonPressed{
    SKAction *moveLeft = [SKAction moveToX:-buttonScale*0.4 duration:0.2];
    moveLeft.timingMode =SKActionTimingEaseOut;
    [button runAction:[SKAction group:@[moveLeft,
                                        [SKAction playSoundFileNamed:@"menuhit.wav" waitForCompletion:NO]]]];
    [self showMenu];
}
- (void)showMenu{
    if (menuLevel<3) {
        menuLevel++;
    }
    if(menuLevel == 1){
        [self presentLevel:1];

    }else if (menuLevel == 2) {
        [self presentLevel:2];
    }

    else if (menuLevel == 3) {
        [self presentSoloScene];
    }
}
- (void)presentLevel:(int)level{
    menuLevel = level;
    [button removeActionForKey:@"moveBackTheBigOSU"];
    [menuLevel1 removeAllActions];
    [menuLevel2 removeAllActions];
    SKAction *showLevelButtons  = [SKAction group:@[[SKAction fadeAlphaTo:1 duration:0.2],
                                                    [SKAction moveToX:buttonScale*0.2 duration:0.2]
                                                    ]];
    SKAction *waitAndHideLevelButtons = [SKAction sequence:@[[SKAction waitForDuration:7],
                                                             [SKAction group:@[[SKAction moveToX:0 duration:1],
                                                                               [SKAction fadeAlphaTo:0 duration:0.5],
                                                                               [SKAction runBlock:^(){
                                                                                    SKAction *moveBack =[SKAction moveToX:0 duration:GMP.currentBps];
                                                                                    [button runAction:moveBack withKey:@"moveBackTheBigOSU"];
                                                                               }]
                                                                               ]],
                                                             [SKAction runBlock:^(){menuLevel = 0;}]
                                                             ]];
    SKAction *hideLevel = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],
                                               [SKAction moveToX:0 duration:0]
                                               ]];
    if (level == 1) {
        [menuLevel2 runAction:hideLevel];
        [menuLevel1 runAction:showLevelButtons];
        [menuLevel1 runAction:waitAndHideLevelButtons];
    }else if (level == 2) {
        [menuLevel1 runAction:hideLevel];
        [menuLevel2 runAction:showLevelButtons];
        [menuLevel2 runAction:waitAndHideLevelButtons];
    }
    
}
- (void)presentSoloScene{
    if ([[[SettingsDealer alloc] init] firstConfigured]) {
        SingleSongSelectScene *soloScene = [SingleSongSelectScene sceneWithSize:callerScene.view.window.frame.size];
        [callerScene.view presentScene:soloScene transition:[SKTransition fadeWithColor:[NSColor blackColor] duration:0.5]];
    }
}
@end
