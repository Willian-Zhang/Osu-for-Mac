//
//  SKMusicPlayerControllerNode.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-7.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//
typedef NS_ENUM(NSInteger, MusicPlayerControllerInfoDisplayMode) {
	MusicPlayerControllerInfoDisplayAutohide       = 0,
	MusicPlayerControllerInfoDisplayAlways         = 1
};

#import <SpriteKit/SpriteKit.h>

@class MPCNextNode;
@class MPCNowPlayingNode;
@class MPCInfoNode;
@class SKSceneWithAdditions;

@interface SKMusicPlayerControllerNode : SKSpriteNode{
    SKSceneWithAdditions *callerScene;
    MPCNowPlayingNode *nowPlaying;
    SKNode *buttons;
    SKNode *previous;
    SKNode *play;
    SKNode *pause;
    SKNode *stop;
    MPCNextNode *next;
    MPCInfoNode *info;
}
@property MusicPlayerControllerInfoDisplayMode infoDisplayMode;

- (id)initWithScene:(SKSceneWithAdditions *)scene;
- (void)updateNowPlaying:(NSString *)title;


@end
