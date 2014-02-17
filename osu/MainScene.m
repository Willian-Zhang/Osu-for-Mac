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
#import "SettingsDealer.h"

#import "DBTimingPoint.h"
#import "Beatmap.h"

#import "FirstRunWindowController.h"
#import "GlobalMusicPlayer.h"

#import "SKMusicPlayerControllerNode.h"
#import "TheBigOSU.h"

#import "SKMessageNode.h"
#import "SingleSongSelectScene.h"


@implementation MainScene



#pragma mark 初始化
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
        self.backgroundColor = [SKColor colorWithRed:0.08 green:0.46 blue:0.98 alpha:1.0];
        


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
    theBigOSU = [[TheBigOSU alloc] initWithScene:self];
    theBigOSU.zPosition = 10;
    theBigOSU.position = CGPointZero;
    [self addChild:theBigOSU];
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
        [theBigOSU synchronizePopingTo:super.GMP.mapPlaying];
        [musicControllerNode updateNowPlaying:super.GMP.mapPlaying.title];
    }
}

- (void)peacePoping{
    [theBigOSU runAction:[SKAction speedTo:1 duration:0]];
    SKEmitterNode *stars = (SKEmitterNode *)([self childNodeWithName:@"backgroundStars"]);
    stars.particleBirthRate = 2;

}
- (void)displayFirstRun{
    [self displayFirstRunSettingsWithCompletion:^(BOOL result){
        if (result == NO){
            [self displayWarning:NSLocalizedString(@"You have to finish the Settings first!", @"First Run Setting Required Message")];
            return ;
        }else if (result == YES){
            [self displayWarning:NSLocalizedString(@"You may go to \"Play → Solo\" now〜", @"First Run Setting Configure Done Message")];
            //here
        }
    }];
}
- (void)displayFirstRunSettingsWithCompletion:(void (^)(BOOL result))block{
    [self displayMessage:NSLocalizedString(@"First time? Follow the guide please〜", @"First time Notice")];

    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:1],
                                         [SKAction runBlock:^(void){
        firstRunController = [[FirstRunWindowController alloc] initWithWindowNibName:@"FirstRunWindow"];
        [firstRunController showWindow:self];
        [firstRunController showRelativeToRect:self.view.frame
                                        ofView:self.view preferredEdge:NSMinYEdge completion:block];
    }]
                                         ]]];
}
#pragma mark 响应事件 - Resize
- (void)didChangeSize:(CGSize)oldSize{
    [super didChangeSize:oldSize];
    [theBigOSU resizeTo:self.frame];
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

#pragma mark 响应事件 - 主要
- (void)GMPdidMeetKeyTimingPointFor:(Beatmap *)beatmap{
    if ([beatmap indexOfKeyTimingPointsAt:super.GMP.currentTime] != 0) {
        [theBigOSU synchronizePopingTo:beatmap];
    }
}
- (void)GMPwillEndPlaying:(Beatmap *)beatmap{
    [self peacePoping];
}
- (void)GMPdidEndPlayingAndPlays:(Beatmap *)beatmap{
//    SKEmitterNode *stars = (SKEmitterNode *)([self childNodeWithName:@"backgroundStars"]);
//    stars.particleBirthRate = theBigOSUSpeed * 10;
    //if ([beatmap indexOfKeyTimingPointsAt:super.GMP.currentTime] == 0) {
        [theBigOSU synchronizePopingTo:beatmap];
    //}
    [musicControllerNode updateNowPlaying:beatmap.title];
}

- (void)showMainMenu{
}



#pragma mark 响应事件 - 系统


#pragma mark functions
- (float)limitScaleWidthForSize:(CGSize )size{
    float limitScaleWidth = size.height;
    if (limitScaleWidth > size.width) {
        limitScaleWidth = size.width;
    }
    return limitScaleWidth;
}

@end
