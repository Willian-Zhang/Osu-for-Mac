//
//  AppDelegate.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"

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
            
        }else if (result == NSFileHandlingPanelCancelButton){
            [NSApp terminate:self];
        }
    }];
}
- (void)persentSelectorScene{
    SKScene *scene = [MyScene sceneWithSize:CGSizeMake(1280, 720)];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    [self.skView presentScene:scene];
    
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
