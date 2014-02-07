//
//  SKMusicPlayerControllerNode.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SKSceneWithAdditions;

@interface SKMusicPlayerControllerNode : SKNode{
    SKSceneWithAdditions *callerScene;
    SKNode *previous;
    SKNode *play;
    SKNode *pause;
    SKNode *stop;
    SKNode *next;
    
}


- (id)init:(SKSceneWithAdditions *)sender;


@end
