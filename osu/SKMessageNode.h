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
- (void)createMessageMaskWithLines:(int)lineNumber;
- (SKLabelNode *)messageLabelWithString:(NSString *)aString onLine:(int)lineCount;
- (void)createMessageLabelWithString:(NSString *)aString onLine:(int)lineCount;

@end
