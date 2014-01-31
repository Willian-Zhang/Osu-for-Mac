//
//  FirstRunWindowController.h
//  Osu for Mac!
//
//  Created by Willian on 14-1-29.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum{
    ConfigureFailed  = 0,
    ConfigureSucceed = 1
};
typedef void(^firstRunCompletion)(NSInteger);

@interface FirstRunWindowController : NSWindowController<NSPopoverDelegate>{
    firstRunCompletion blockKeeped;
    NSWindow *callerWindow;
}

@property (assign) IBOutlet NSPopover *firstRunPopover;
@property (assign) IBOutlet NSView *popoverContainerView;
@property (assign) IBOutlet NSView *selectModeView;
@property (assign) IBOutlet NSView *connectWinDifferentView;
@property (assign) IBOutlet NSView *connectWinView;

/*
 * Shared
 */
- (IBAction)cancelButtonPushed:(NSButton *)sender;

/*
 * Selector
 */
- (IBAction)connectButtonPushed:(NSButton *)sender;
- (IBAction)newButtonPushed:(NSButton *)sender;

/*
 * Connect
 */
- (IBAction)selectWinDirectory:(NSButton *)sender;
- (IBAction)saveDifferentSelected:(NSButton *)sender;
- (IBAction)firstConfigueDone:(NSButton *)sender;
- (IBAction)firstConfigueDifferentDone:(NSButton *)sender;


/*
 * Select View
 */
@property (assign) IBOutlet NSTextField *titleLabel;
@property (assign) IBOutlet NSButton *connectButtonOutlet;
@property (assign) IBOutlet NSButton *startNewButtonOutlet;
@property (assign) IBOutlet NSButton *cancelButtonOutlet;

/*
 * Connect Windows View
 */
@property (assign) IBOutlet NSTextField *windowsDirectoryLabel;
@property (assign) IBOutlet NSTextField *windowsDirectoryBox;
@property (assign) IBOutlet NSButton *windowsDirectoryButtonSelectOutlet;
@property (assign) IBOutlet NSButton *windowsDirectorySelectDifferentOutlet;
@property (assign) IBOutlet NSButton *windowsDirectoryLaterButtonOutlet;
@property (strong) IBOutlet NSButton *windowsDirectoryDoneOutlet;

/*
 * Connect Windows Different View
 */
@property (assign) IBOutlet NSTextField *windowsDirectoryReadLabel;
@property (assign) IBOutlet NSTextField *windowsDirectoryReadBox;
@property (assign) IBOutlet NSButton *windowsDirectoryReadButtonSelectLabel;
@property (assign) IBOutlet NSTextField *windowsDirectorySaveLabel;
@property (assign) IBOutlet NSTextField *windowsDirectorySaveBox;
@property (assign) IBOutlet NSButton *windowsDirectorySaveButtonSelectLabel;
@property (assign) IBOutlet NSButton *windowsDirectoryDifferentLaterButtonOutlet;
@property (assign) IBOutlet NSButton *windowsDirectoryDifferentSelectBackOutlet;
@property (strong) IBOutlet NSButton *windowsDirectoryDifferentDoneOutlet;


- (void)showRelativeToRect:(CGRect)rect ofView:(NSView *)view preferredEdge:(NSRectEdge)edge completion:(void(^)(NSInteger result))block;

@end
