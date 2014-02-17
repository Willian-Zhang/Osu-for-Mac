//
//  TheBigOSUMenuButtons.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-18.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TheBigOSUMenuPlay : SKSpriteNode

@end

@interface TheBigOSUMenuExit : SKSpriteNode

@end


@interface TheBigOSUMenuButtons : SKNode{
    TheBigOSUMenuPlay *play;
    TheBigOSUMenuExit *exit;
}

@end

