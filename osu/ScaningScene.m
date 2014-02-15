//
//  ScaningScene.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "ScaningScene.h"
#import "SettingsDealer.h"
#import "AppDelegate.h"
#import "ApplicationSupport.h"

@implementation ScaningScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        loadingLabelGroup = [[SKNode alloc] init];
        loadingLabelGroup.name = @"loadingLabelGroup";
        [self addChild:loadingLabelGroup];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        appSupport = [appDelegate appSupport];
    }
    return self;
}
#pragma mark Reports

- (void)appSupportReportStartEvent:(AppSupportReportEvents)event
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if       (event == AppSupportReportLoadBeatmap) {
            [self displayMessage:NSLocalizedString(@"Scaning Files...", @"Scaning Files Label")];
        }else if (event == AppSupportReportUpdateDatabase){
            [self displayMessage:NSLocalizedString(@"Updates required!", @"AllBeatmapsReady is NO; Updates required Label")];
        }else if (event == AppSupportReportImport){
            [self displayMessage: NSLocalizedString(@"Importing Database from Windows version ...", @"Importing Database Label")];
        }
    });
}
- (void)appSupportReportFinishEvent:(AppSupportReportEvents)event
{
        dispatch_async(dispatch_get_main_queue(), ^(void){
    if       (event == AppSupportReportImport) {
        [self displayMessage:NSLocalizedString(@"Import Succeed!", @"Load Succeeded Message")];
    }
        });
}
//- (void)appSupportReportMessgae:(NSString *)message withEvent:(AppSupportReportEvents)event
//{
//    
//}
- (void)appSupportReportError:(NSString *)errorString withEvent:(AppSupportReportEvents)event
{
     dispatch_async(dispatch_get_main_queue(), ^(void){
    if       (event == AppSupportReportImport) {
        [self displayMessage:NSLocalizedString(@"Import fialed! Perhaps the Windows Osu! Database was corrupted!", @"Load Fialed Message")];
    }
     });
}

#pragma mark Logics
- (void)makeAllBeatmapsReady:(ScaningCompletion)completionBlock{
    dispatch_queue_t makeReadyQueue = dispatch_queue_create([@"makeReadyQueue" UTF8String], nil);
    dispatch_async(makeReadyQueue, ^(void){
        NSError *error = nil;
        if (![appSupport makeAllBeatmapsReadyAndReturnError:&error]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1],
                                                     [SKAction runBlock:^(void){ completionBlock(NO); }]]]];
            });
        }else if (error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1],
                                                     [SKAction runBlock:^(void){ completionBlock(NO); }]]]];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1],
                                                     [SKAction runBlock:^(void){ completionBlock(YES); }]]]];
            });
        }
    });
}


#pragma mark 视图
- (void)displayMessage:(NSString *)messageString{
    [self moveupLabelArray];
    SKLabelNode *loadingLabel = [self loadingLabelWithString:messageString];
    [loadingLabelGroup addChild:loadingLabel];
}
- (void)displayWarning:(NSString *)messageString{
    [self displayMessage:messageString];
}
- (void)addLoadingLineWithString:(NSString *)aString{
    [self moveupLabelArray];
    SKLabelNode *loadingLabel = [self loadingLabelWithString:[NSString stringWithFormat:@"Loading %@ ...",aString]];
    [loadingLabelGroup addChild:loadingLabel];
}
- (SKLabelNode *)loadingLabelWithString:(NSString *)label{
    SKLabelNode *loadingLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvitica"];
    loadingLabel.text = label;
    loadingLabel.fontSize = 25;
    loadingLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
    return loadingLabel;
}
- (void)moveupLabelArray{
    for (SKNode *oldNode in [loadingLabelGroup children]) {
        SKAction *moveUpAction = [SKAction group:@[
                                                   [SKAction moveByX:0 y:30 duration:0.2],
                                                   [SKAction fadeAlphaBy:-0.15 duration:0.2]
                                                   ]];
        [oldNode runAction:moveUpAction];
        if (oldNode != nil) {
            if (oldNode.alpha == 0) {
                [oldNode runAction:[SKAction removeFromParent]];
            }
        }
    }
}

#pragma mark 响应事件 - 系统


@end
