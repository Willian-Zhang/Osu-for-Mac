//
//  FirstRunWindowController.m
//  Osu for Mac!
//
//  Created by Willian on 14-1-29.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "FirstRunWindowController.h"

@interface FirstRunWindowController ()

@end



@implementation FirstRunWindowController

@synthesize firstRunPopover;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)cancelButtonPushed:(NSButton *)sender {
    [self.firstRunPopover performClose:sender];
    blockKeeped(ConfigureFailed);
}

- (void)showRelativeToRect:(CGRect)rect ofView:(NSView *)view preferredEdge:(NSRectEdge)edge completion:(firstRunCompletion)block{
    [self.firstRunPopover showRelativeToRect:rect ofView:view preferredEdge:edge];
    blockKeeped = block;
}

@end
