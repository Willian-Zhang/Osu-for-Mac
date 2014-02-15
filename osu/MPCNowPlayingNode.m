//
//  MPCNowPlayingNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-15.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "MPCNowPlayingNode.h"

@implementation MPCNowPlayingNode

- (id)init
{
    self = [super init];
    if (self) {
        SKTexture *texture = [SKTexture textureWithImageNamed:@"menu-np"];
        SKSpriteNode *img = [SKSpriteNode spriteNodeWithTexture:texture];
        img.position = CGPointMake(+341-90, -15);
        label = [[SKLabelNode alloc] init];
        label.position = CGPointMake(0, -16);
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.fontSize = 19;
        label.zPosition = 2;
        [self addChild:label];
        [self addChild: img];
    }
    return self;
}
@synthesize width;
-(float)width{
    return label.calculateAccumulatedFrame.size.width +10;
}
@synthesize text = _text;
- (NSString *)text{
    return label.text;
}
- (void)setText:(NSString *)text{
    label.text = text;
}
@end
