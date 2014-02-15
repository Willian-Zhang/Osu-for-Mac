//
//  SKMusicPlayerControllerNode.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MPCNextNode;

@interface SKMusicPlayerControllerNode : SKSpriteNode{
    SKNode *previous;
    SKNode *play;
    SKNode *pause;
    SKNode *stop;
    MPCNextNode *next;
    
}



//- (id)init:(SKSceneWithAdditions *)sender;


@end
