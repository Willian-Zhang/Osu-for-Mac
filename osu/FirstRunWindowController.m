//
//  FirstRunWindowController.m
//  Osu for Mac!
//
//  Created by Willian on 14-1-29.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FirstRunWindowController.h"
#import "SettingsDealer.h"

@interface FirstRunWindowController ()

@end


@implementation FirstRunWindowController

@synthesize firstRunPopover;

#pragma mark initlize
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
        callerWindow = window;
        // Initialization code here.
    }
    return self;
}
- (void)showWindow:(id)sender{
    [super showWindow:sender];
    callerWindow = [[(SKScene *)(sender) view] window];
}
- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (void)showRelativeToRect:(CGRect)rect ofView:(NSView *)view preferredEdge:(NSRectEdge)edge completion:(firstRunCompletion)block{
    [self.firstRunPopover showRelativeToRect:rect ofView:view preferredEdge:edge];
    //inits
    [self changePopoverViewTo:self.selectModeView];
    [self initLabels];
    blockKeeped = block;
}
- (void)initLabels{
    //select
    [self.titleLabel setStringValue:NSLocalizedString(@"Select:", @"Select:")];
    [self.connectButtonOutlet setTitle:NSLocalizedString(@"Connect with my Windows version Osu!", @"Connect with Windows Osu!")];
    [self.startNewButtonOutlet setTitle:NSLocalizedString(@"Start a brand new Osu for Mac!", @"Start new Osu!")];
    [self.cancelButtonOutlet setTitle:NSLocalizedString(@"Not now", @"Not now for first play")];
    //connect
    [self.windowsDirectoryLabel setStringValue:NSLocalizedString(@"Windows Osu!:", @"Windows: Label")];
    [self.windowsDirectoryButtonSelectOutlet setTitle:NSLocalizedString(@"Select...", @"Select...")];
    [self.windowsDirectorySelectDifferentOutlet setTitle:NSLocalizedString(@"Save my new files to another folder", @"Show save different folder part")];
    [self.windowsDirectoryLaterButtonOutlet setTitle:NSLocalizedString(@"Later", @"Later")];
    [self.windowsDirectoryDoneOutlet setTitle:NSLocalizedString(@"Done", @"First Configue Done Label")];
    //connect diff
    [self.windowsDirectoryReadLabel setStringValue:NSLocalizedString(@"Windows Osu!:", @"Windows: Label")];
    [self.windowsDirectoryReadButtonSelectLabel setTitle:NSLocalizedString(@"Select...", @"Select...")];
    [self.windowsDirectorySaveLabel setStringValue:NSLocalizedString(@"Save Folder:", @"Save Folder: Label")];
    [self.windowsDirectorySaveButtonSelectLabel setTitle:NSLocalizedString(@"Select...", @"Select...")];
    [self.windowsDirectoryDifferentLaterButtonOutlet setTitle:NSLocalizedString(@"Later", @"Later")];
    [self.windowsDirectoryDifferentSelectBackOutlet setTitle:NSLocalizedString(@"Save new files to different folders", @"Hide save different folder part")];
    [self.windowsDirectoryDifferentDoneOutlet setTitle:NSLocalizedString(@"Done", @"First Configue Done Label")];
    
}

#pragma mark changes
- (void)updateReadBox{
    NSURL *readDir = [[[SettingsDealer alloc] init] loadDirectory];
    NSString *readDirStr = [readDir relativePath];
    [self.windowsDirectoryReadBox setStringValue:readDirStr];
    [self.windowsDirectoryBox setStringValue:readDirStr];
}
- (void)changePopoverViewTo:(NSView *)view{
    [self.popoverContainerView setSubviews:[NSArray array]];
    self.popoverContainerView.frame = view.frame;
    
    [self.firstRunPopover setContentSize:view.frame.size];
    [self.popoverContainerView addSubview:view];
}
- (void)selectFolder{

}
#pragma mark function
- (BOOL)checkWritingPermissionForURL:(NSURL *)theURL{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *filePath = [theURL URLByAppendingPathComponent:@"osu-for-mac-permission-check.osu"];
    NSString *filePathString = [filePath relativePath];
    if ([fileManager createFileAtPath:filePathString contents:nil attributes:nil]) {
        if ([fileManager removeItemAtURL:filePath error:nil]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)checkIsValidDirectoryForURL:(NSURL *)theURL{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *songDirPath = [theURL URLByAppendingPathComponent:@"Songs" isDirectory:YES];
    if ([fileManager fileExistsAtPath:[songDirPath path] isDirectory:nil]) {
        return YES;
    }
    return NO;
}
#pragma mark actions
- (IBAction)connectButtonPushed:(NSButton *)sender {
    [self changePopoverViewTo:self.connectWinView];
}

- (IBAction)newButtonPushed:(NSButton *)sender {
    
}

- (IBAction)cancelButtonPushed:(NSButton *)sender {
    [self.firstRunPopover performClose:sender];
    [callerWindow makeKeyAndOrderFront:sender];
    blockKeeped(NO);
}

- (IBAction)selectWinDirectory:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:NO];
    //[panel setPrompt:NSLocalizedString(@"OK", @"Selection Done")];
    [panel setTitle:NSLocalizedString(@"Please select the Osu! Directory on Windows", @"Select Widnows Osu Window Title")];
    panel.allowsMultipleSelection = NO;
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            SettingsDealer *settings = [[SettingsDealer alloc] init];
            [settings setLoadDirectory:panel.URL];
            [self updateReadBox];
            if ([self checkWritingPermissionForURL:panel.URL]) {
                [self.windowsDirectoryDoneOutlet setEnabled:YES];
                [self.windowsDirectoryDifferentSelectBackOutlet setEnabled:YES];
            }else{
                [self.windowsDirectoryDoneOutlet setEnabled:NO];
                [self.windowsDirectoryDifferentSelectBackOutlet setEnabled:NO];
                [self changePopoverViewTo:self.connectWinDifferentView];
                
            }
            
        }else if (result == NSFileHandlingPanelCancelButton){
            
        }
    }];
}

- (IBAction)saveDifferentSelected:(NSButton *)sender {
    if (sender.state == NSOnState) {
        [self changePopoverViewTo:self.connectWinDifferentView];
        [self.windowsDirectoryDifferentSelectBackOutlet setState:NSOnState];
    }else if (sender.state == NSOffState){
        [self changePopoverViewTo:self.connectWinView];
        [self.windowsDirectorySelectDifferentOutlet setState:NSOffState];
    }
}

- (IBAction)firstConfigueDone:(NSButton *)sender {
    SettingsDealer *settings = [[SettingsDealer alloc] init];
    NSURL *readDir = [settings loadDirectory];
    [settings setSaveDirectory:readDir];
    [settings setFirstConfigured:YES];
    [self.firstRunPopover performClose:sender];
    blockKeeped(YES);
}

- (IBAction)firstConfigueDifferentDone:(NSButton *)sender {
    
}
@end
