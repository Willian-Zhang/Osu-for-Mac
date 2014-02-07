//
//  AppDelegate.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "AppDelegate.h"

#import <SpriteKit/SpriteKit.h>

#import "GlobalMusicPlayer.h"
#import "SKSceneWithAdditions.h"
#import "ImportedOsuDB.h"

#import "ScaningScene.h"
#import "MainScene.h"
#import "SettingsDealer.h"
#import "ApplicationSupport.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize appSupport;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    appSupport = [[ApplicationSupport alloc] init];
    self.globalMusicPlayer = [[GlobalMusicPlayer alloc] init];
    
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount= YES;
    //self.skView.asynchronous = NO;
    //self.skView.frameInterval = 100;
    
    

    
    SettingsDealer *settings = [[SettingsDealer alloc] init];
    if (![settings firstConfigured]) {
        MainScene *mainScene = [self startMainScene];
        [mainScene displayFirstRunSettingsWithCompletion:^(NSInteger result){
            if (result == FirstRunConfigureSucceed) {
                
            }else if (result == FirstRunConfigureFailed){
                [mainScene displayMessage:NSLocalizedString(@"You have to finish the Settings first!", @"First Run Setting Required Message")];
            }
        }];
    }else{
        MainScene *mainScene = [self startMainScene];
        [mainScene initBGM];
    }    
}
- (MainScene *)startMainScene{
    MainScene *mainScene = [MainScene sceneWithSize:CGSizeMake(1152, 720)];
    mainScene.scaleMode = SKSceneScaleModeResizeFill;
    [self.skView presentScene:mainScene];
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window makeFirstResponder:self.skView.scene];
    return mainScene;
}



- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    NSError *error;
    if (appSupport.managedObjectContext != nil) {
        //hasChanges方法是检查是否有未保存的上下文更改，如果有，则执行save方法保存上下文
        if ([appSupport.managedObjectContext hasChanges] && ![appSupport.managedObjectContext save:&error]) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
            abort();
        }  
    }
    return YES;
}

@end
