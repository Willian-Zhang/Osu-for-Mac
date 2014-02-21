//
//  SKBackNode.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-21.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"

@interface SKBackNode : SKEffectNode <SKNodeMouseOverEvents>{
    SKSpriteNode *back;
}

- (id)initWithScene:(SKSceneWithAdditions *)scene;

@end
