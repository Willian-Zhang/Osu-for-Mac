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


#pragma mark Logics
- (void)loadAllBeatmaps:(scaningCompletion)completion{
    if ([appSupport isDatabaseExist]) {
        
    }else{
        NSURL *loadURL = [[[SettingsDealer alloc] init] loadDirectory];
        NSURL *dbURL = [loadURL URLByAppendingPathComponent:@"osu!.db" isDirectory:NO];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[dbURL path] isDirectory:NO]) {
            [self importDBFromURL:dbURL completion:completion];
        }else{
            [self scanFilesInSongsWithCompletion:completion];
        }
    }
}
- (void)scanFilesInSongsWithCompletion:(scaningCompletion)completion{
    SKLabelNode *loadingLabel = [self loadingLabelWithString:NSLocalizedString(@"Scaning Files...", @"Scaning Files Label")];
    [loadingLabelGroup addChild:loadingLabel];
}

- (void)importDBFromURL:(NSURL *)dbURL completion:(scaningCompletion)completion{
    SKLabelNode *loadingLabel = [self loadingLabelWithString:NSLocalizedString(@"Importing Database from Windows version ...", @"Importing Database Label")];
    [loadingLabelGroup addChild:loadingLabel];
    
    //WinOsuInterpreter *winConnector = [[WinOsuInterpreter alloc] init];
    
    dispatch_queue_t importQueue = dispatch_queue_create([@"importQueue" UTF8String], nil);
    dispatch_async(importQueue, ^(void){
        if ([appSupport importWindowsDatabaseOfURL:dbURL]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self moveupLabelArray];
                SKLabelNode *loadingLabel = [self loadingLabelWithString:NSLocalizedString(@"Import Succeed!", @"Load Succeeded Message") ];
                [loadingLabelGroup addChild:loadingLabel];
                [self runAction:[SKAction sequence:@[
                                                    [SKAction waitForDuration:1],
                                                    [SKAction runBlock:             completion]]
                                 ]];
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self moveupLabelArray];
                SKLabelNode *loadingLabel = [self loadingLabelWithString:NSLocalizedString(@"Import fialed! Perhaps the Windows Osu! Database was corrupted!", @"Load Fialed Message") ];
                [loadingLabelGroup addChild:loadingLabel];
            });
        }
//        [winConnector importDatabaseFromWindowsVersionOsuDB:dbURL withReport:^(NSString *title){
//            dispatch_async(dispatch_get_main_queue(), ^(void){
//                [self CompleteLoading];
//                
//            });
//        }];
    });
    
    
}

#pragma mark 视图
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
