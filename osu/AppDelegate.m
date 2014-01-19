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

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self selectFolder];
    
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
            ScaningScene *scaningScene = [ScaningScene sceneWithSize:CGSizeMake(1280, 720)];
            scaningScene.scaleMode = SKSceneScaleModeAspectFit;
            [self.skView presentScene:scaningScene];
            self.skView.showsFPS = YES;
            self.skView.showsNodeCount= YES;
            
            [scaningScene addLoadingLineWithString:@"1"];
            [scaningScene addLoadingLineWithString:@"2"];
            [scaningScene addLoadingLineWithString:@"3"];
            [scaningScene addLoadingLineWithString:@"3"];
            [scaningScene addLoadingLineWithString:@"4"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
            [scaningScene addLoadingLineWithString:@"5"];
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

@end
