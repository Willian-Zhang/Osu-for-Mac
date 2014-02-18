//
//  TheBigOSUMenuButtons.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-18.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKSceneWithAdditions.h"

@class TheBigOSU;
@interface TheBigOSUMenuButton : SKSpriteNode <SKNodeMouseOverEvents>{
    TheBigOSU *rootNode;
    SKTexture *texture;
    SKTexture *overTexture;
}
@property (readwrite) NSString *image;

@end

@interface TheBigOSUMenuLevel : SKNode{
    TheBigOSU *rootNode;
}
- (id)initWithRoot:(TheBigOSU *)node;
- (void)add:(TheBigOSUMenuButton *)button at:(int)index;
@end

@interface TheBigOSUMenuPlay : TheBigOSUMenuButton
@end
@interface TheBigOSUMenuExit : TheBigOSUMenuButton
@end

@interface TheBigOSUMenuSolo : TheBigOSUMenuButton
@end
@interface TheBigOSUMenuBack : TheBigOSUMenuButton
@end

@interface TheBigOSUMenuLevel1 : TheBigOSUMenuLevel{
    TheBigOSUMenuExit *exit;
}
@end
@interface TheBigOSUMenuLevel2 : TheBigOSUMenuLevel{
    TheBigOSUMenuSolo *solo;
    TheBigOSUMenuBack *back;
}
@end
