//
//  ScaningScene.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "ScaningScene.h"
#import "SettingsDealer.h"

@implementation ScaningScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        SKNode *loadingLabelGroup = [[SKNode alloc] init];
        loadingLabelGroup.name = @"loadingLabelGroup";
        [self addChild:loadingLabelGroup];
        SKLabelNode *loadingLabel = [self loadingLabelWithString:NSLocalizedString(@"Scaning Files...", @"Scaning Files Label")];
        [loadingLabelGroup addChild:loadingLabel];
        
    }
    return self;
}


#pragma mark Logics
- (void)loadAllBeatmaps{
    NSURL *loadURL = [[[SettingsDealer alloc] init] getLoadDirectory];
    NSURL *dbURL = [loadURL URLByAppendingPathComponent:@"osu!.db" isDirectory:NO];

    
}




#pragma mark 视图
- (void)addLoadingLineWithString:(NSString *)aString{
    [self moveupLabelArray];
    SKLabelNode *loadingLabel = [self loadingLabelWithString:[NSString stringWithFormat:@"Loading %@ ...",aString]];
    SKNode *loadingLabelGroup = [self childNodeWithName:@"loadingLabelGroup"];
    [loadingLabelGroup addChild:loadingLabel];
}
- (void)CompleteLoading{
    [self moveupLabelArray];
    SKLabelNode *loadingLabel = [self loadingLabelWithString:@"All loads completed!"];
    [self addChild:loadingLabel];
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
    SKNode *loadingLabelGroup = [self childNodeWithName:@"loadingLabelGroup"];
    SKAction *moveUpAction = [SKAction group:@[
                                              [SKAction moveByX:0 y:30 duration:0.5],
                                              [SKAction fadeAlphaBy:-0.15 duration:0.5]
                                              ]];
    [loadingLabelGroup runAction:moveUpAction];
    
    for (SKNode *oldNode in [loadingLabelGroup children]) {
        if (oldNode != nil) {
            if (oldNode.alpha == 0) {
                [oldNode runAction:[SKAction removeFromParent]];
            }
        }
    }
}

#pragma mark 响应事件 - 系统


@end
