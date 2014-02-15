//
//  MPCNowPlayingNode.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-15.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MPCNowPlayingNode : SKNode{
    SKLabelNode *label;
}

@property NSString *text;
@property (readonly) float width;
@end
