//
//  ScaningScene.h
//  osu
//
//  Created by Willian on 14-1-20.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScaningScene : SKScene{
    int loadingLabelNumberCount;
}

-(void)addLoadingLineWithString:(NSString *)aString;

@end