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
}

@property (assign) IBOutlet NSPopover *firstRunPopover;

@property (assign) IBOutlet NSButton *cancelButtonOutlet;
- (IBAction)cancelButtonPushed:(NSButton *)sender;


- (void)showRelativeToRect:(CGRect)rect ofView:(NSView *)view preferredEdge:(NSRectEdge)edge completion:(void(^)(NSInteger result))block;

@end
