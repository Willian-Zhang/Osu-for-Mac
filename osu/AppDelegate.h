//
//  AppDelegate.h
//  osu
//

//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SKView;

@class ApplicationSupport;
@class GlobalMusicPlayer;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;
@property (retain) ApplicationSupport *appSupport;
@property (retain) GlobalMusicPlayer *globalMusicPlayer;

@end
