//
//  AppDelegate.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"
#import "ScaningScene.h"
#import "MainScene.h"
#import "SettingsDealer.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount= YES;
    //self.skView.asynchronous = NO;
    //self.skView.frameInterval = 100;
    MainScene *mainScene = [self startMainScene];
    SettingsDealer *settings = [[SettingsDealer alloc] init];
    
    NSURL *saveDirectory;
    NSURL *loadDirectory;
    if ([settings isFirstRun]) {
        [mainScene displayFirstRunSettingsWithCompletion:^(NSInteger result){
            if (result == FirstRunConfigureSucceed) {
                
            }else if (result == FirstRunConfigureFailed){
                [mainScene displayMessage:NSLocalizedString(@"You have to finish the Settings first!", @"First Run Setting Required Message")];
            }
        }];
    }else{
        saveDirectory = [settings getSaveDirectory];
        loadDirectory = [settings getLoadDirectory];
    }
    //[self selectFolder];
    
}
- (void)startScaningScene{
    ScaningScene *scaningScene = [ScaningScene sceneWithSize:CGSizeMake(1152, 720)];
    scaningScene.scaleMode = SKSceneScaleModeResizeFill;
    [self.skView presentScene:scaningScene];
    
    [scaningScene addLoadingLineWithString:@"1"];
    [scaningScene addLoadingLineWithString:@"2"];
}
- (MainScene *)startMainScene{
    MainScene *mainScene = [MainScene sceneWithSize:CGSizeMake(1152, 720)];
    mainScene.scaleMode = SKSceneScaleModeResizeFill;
    [self.skView presentScene:mainScene];
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window makeFirstResponder:self.skView.scene];
    return mainScene;
}
- (void)selectFolder{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setPrompt:@"OK"];
    [panel setTitle:@"Please select the osu! song dirctory you store your osu beatmaps"];
    panel.allowsMultipleSelection = NO;
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *songsDir = panel.URL;
            //NSLog(@"%@",[songsDir.path stringByResolvingSymlinksInPath]);
            
        }else if (result == NSFileHandlingPanelCancelButton){
            [NSApp terminate:self];
        }
    }];
}
- (void)persentSelectorScene{
    SKScene *scene = [MyScene sceneWithSize:CGSizeMake(1280, 720)];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    [self.skView presentScene:scene];
    
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

#pragma mark settings
- (NSString *)applicationSupportFolder {
    
    NSString *applicationSupportFolder = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if ( [paths count] == 0 ) {
        NSRunAlertPanel(@"Alert", @"Can't find application support folder", @"Quit", nil, nil);
        [[NSApplication sharedApplication] terminate:self];
    } else {
        applicationSupportFolder = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Osu for Mac!"];
    }
    return applicationSupportFolder;
}

@end
