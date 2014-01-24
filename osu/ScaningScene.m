//
//  ScaningScene.m
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "ScaningScene.h"

@implementation ScaningScene
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        loadingLabelNumberCount = 0;
        SKLabelNode *loadingLabel = [self loadingLabelWithString:@"Scaning Files..."];
        [self addChild:loadingLabel];
    }
    return self;
}
- (void)addLoadingLineWithString:(NSString *)aString{
    [self moveupLabelArray];
    SKLabelNode *loadingLabel = [self loadingLabelWithString:[NSString stringWithFormat:@"Loading %@ ...",aString]];
    [self addChild:loadingLabel];
}
- (void)CompleteLoading{
    [self moveupLabelArray];
    SKLabelNode *loadingLabel = [self loadingLabelWithString:@"All loads completed!"];
    [self addChild:loadingLabel];
}
/*
 * loadingLabelWithString 存在计数自增
 */
- (SKLabelNode *)loadingLabelWithString:(NSString *)label{
    loadingLabelNumberCount++;
    SKLabelNode *loadingLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvitica"];
    loadingLabel.name =[NSString stringWithFormat:@"%@%d",@"loadingLabel",loadingLabelNumberCount] ;
    loadingLabel.text = label;
    loadingLabel.fontSize = 25;
    loadingLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
    return loadingLabel;
}
- (void)moveupLabelArray{
    SKAction *moveUp  = [SKAction moveByX:0 y:30 duration:0.5];
    SKAction *fadeSome = [SKAction fadeAlphaBy:-0.15 duration:0.5];
    SKAction *groupAction = [SKAction group:@[moveUp,fadeSome]];
    
    for (int count = 1; count <= loadingLabelNumberCount; count++) {
        SKNode *oldNode = [self childNodeWithName:[NSString stringWithFormat:@"%@%d",@"loadingLabel",count]];
        if (oldNode != nil) {
            [oldNode runAction:groupAction];
            if (oldNode.alpha == 0) {
                [oldNode removeFromParent];
            }
        }
    }
}
- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
