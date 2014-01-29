//
//  SKMessageNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-1-27.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKMessageNode.h"

@implementation SKMessageNode
- (id)initWithWidth:(float)width
{
    self = [super init];
    if (self) {
        initWidth = width;
        fontSize = 25;
        lineSpaceSize = 10;
        marginSize = 12;
        [self runAction:[SKAction playSoundFileNamed:@"notify.wav" waitForCompletion:NO]];
        self.name = @"message";
        self.alpha = 0.9;
        self.zPosition = 30;
    }
    return self;
}

- (SKNode *)messageMaskWithLines:(int)lineNumber{
    _lineNumber = lineNumber;
    int height = 2 * marginSize + fontSize * lineNumber + lineSpaceSize * ( lineNumber - 1 )  ;
    
    SKSpriteNode *blackRect = [SKSpriteNode spriteNodeWithColor:[NSColor blackColor] size:CGSizeMake(initWidth, height)];
    blackRect.zPosition = 30;
    blackRect.position = CGPointZero;
    blackRect.name = @"messageMask";
    blackRect.alpha = 0.8;
    return blackRect;
}
- (void)addMessageMaskWithLines:(int)lineNumber{
    SKNode *blackRect = [self messageMaskWithLines:lineNumber];
    [self addChild:blackRect];
}
- (SKLabelNode *)messageLabelWithString:(NSString *)aString onLine:(int)lineCount{
    SKLabelNode *aLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvitica"];
    aLabel.text = aString;
    aLabel.fontSize = fontSize;
    aLabel.color = [NSColor whiteColor];
    aLabel.zPosition = 31;
    aLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    int halfHeight =  marginSize + (fontSize * _lineNumber + lineSpaceSize * ( _lineNumber - 1 ))/2  ;
    aLabel.position = CGPointMake(0, halfHeight-((marginSize+0.5*fontSize)+(lineCount-1)*(fontSize+lineSpaceSize)));
    
    return aLabel;
}
- (void)addMessageLabelWithString:(NSString *)aString onLine:(int)lineCount{
    SKLabelNode *aLabel = [self messageLabelWithString:aString onLine:lineCount];
    [self addChild:aLabel];
}
- (void)fadeOut{
    [self fadeOutIn:3];
}
- (void)fadeOutNow{
    [self fadeOutIn:0];
}
- (void)fadeOutIn:(float)seconds{
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:seconds],
                                         [SKAction fadeOutWithDuration:0.5],
                                         [SKAction removeFromParent]
                                         ]]];
}
@end
