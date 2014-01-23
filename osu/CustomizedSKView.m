//
//  CustomizedSKView.m
//  osu
//
//  Created by Willian on 14-1-21.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "CustomizedSKView.h"

@implementation CustomizedSKView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}
- (void)cursorUpdate:(NSEvent *)event{
    [self doCursorUpdate];
}
- (void)updateTrackingAreas{//Called by NSView
    if (trackingArea != nil) {
        [self removeTrackingArea:trackingArea];
        trackingArea = nil;
    }
    NSTrackingAreaOptions trackingAreaOptions = NSTrackingCursorUpdate | NSTrackingActiveInActiveApp;
    trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingAreaOptions owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    [self performSelector:@selector(doCursorUpdate) withObject:nil afterDelay:0];
}
- (void) doCursorUpdate{
    [[self getCustomCursor] set];
    //NSLog(@"CursorUpdate");
}
- (NSCursor *)getCustomCursor{
    if (cursor == nil) {
        NSString *pathToCursorImage = [[NSBundle mainBundle] pathForResource:@"cursor" ofType:@"png" inDirectory:@"templateskin"];
        NSImage *cursorImage = [[NSImage alloc] initWithContentsOfFile:pathToCursorImage];
        NSPoint cursorPoint = NSMakePoint(cursorImage.size.width/2,cursorImage.size.height/2);
        cursor = [[NSCursor alloc] initWithImage:cursorImage hotSpot:cursorPoint];
    }
    return cursor;
}
@end
