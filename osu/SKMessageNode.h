//
//  SKMessageNode.h
//  Osu for Mac!
//
//  Created by Willian on 14-1-27.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKMessageNode : SKNode{
    float initWidth;
    int fontSize;
    int lineSpaceSize;
    int marginSize;
    int _lineNumber;
}
- (id)initWithWidth:(float)width;
- (SKNode *)messageMaskWithLines:(int)lineNumber;
- (void)addMessageMaskWithLines:(int)lineNumber;
- (SKLabelNode *)messageLabelWithString:(NSString *)aString onLine:(int)lineCount;
- (void)addMessageLabelWithString:(NSString *)aString onLine:(int)lineCount;

- (void)fadeOut;
- (void)fadeOutNow;
- (void)fadeOutIn:(float)seconds;
@end
