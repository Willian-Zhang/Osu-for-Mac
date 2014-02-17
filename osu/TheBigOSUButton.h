//
//  TheBigOSUButton.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-16.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"

@interface TheBigOSUButton : SKNode <SKNodeMouseOverEvents>{
    SKSpriteNode *node;
}

- (id)initWithSize:(CGSize )size;
- (void)resizeTo:(float)size;


@property (readwrite) float hoverFraction;

@end
