//
//  SKBackNode.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-21.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SKBackNode.h"

@implementation SKBackNode
- (id)initWithScene:(SKSceneWithAdditions *)scene
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        NSImage *image = [NSImage imageNamed:@"menu-back"];
        CIImage *ciImage = [CIImage imageWithCGImage:[image CGImageForProposedRect:nil context:nil hints:nil]];
        SKTexture *texture = [SKTexture textureWithImageNamed:@"menu-back"];
        back = [SKSpriteNode spriteNodeWithTexture:texture];
        back.anchorPoint = CGPointZero;
        [self addChild:back];
        CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:1.07] forKey:@"inputEV"];
        [self setShouldEnableEffects:NO];
        self.filter = filter;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
                            CGSizeMake(self.calculateAccumulatedFrame.size.width*2, self.calculateAccumulatedFrame.size.height*2)];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = buttonCategory;
        [scene addContact:self];
    }
    return self;
}
-(void)mouseDown:(NSEvent *)theEvent{
    [self runAction:[SKAction playSoundFileNamed:@"menuback.wav" waitForCompletion:NO]];
    [(SKSceneWithAdditions *)self.scene presentBackScene];
}
- (void)didMouseEnter{
    [self setShouldEnableEffects:YES];
}
- (void)didMouseExit{
    [self setShouldEnableEffects:NO];
}
@end
