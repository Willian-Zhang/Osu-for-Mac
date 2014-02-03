//
//  SKSceneWithAdditions.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSceneWithAdditions : SKScene

@property (nonatomic ) CGPoint lastFrameCursorPosition;
@property (nonatomic , retain) SKNode *cursor;
@property (nonatomic , retain) SKTexture *cursortailTexture;

- (void)displayMessage:(NSString *)messageString;

- (void)leftDown:(NSEvent *)theEvent;
- (void)leftUp:(NSEvent *)theEvent;
- (CGPoint)locationInScene;
@end
