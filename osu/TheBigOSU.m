//
//  TheBigOSU.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-14.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "TheBigOSU.h"

@implementation TheBigOSU
@synthesize frame = _frame;

- (id)initWithFrame:(NSRect)frame
{
    self = [super init];
    if (self) {
        _frame = frame;
    }
    return self;
}

#pragma mark functions
- (float)limitScaleWidthForSize:(CGSize )size{
    float limitScaleWidth = size.height;
    if (limitScaleWidth > size.width) {
        limitScaleWidth = size.width;
    }
    return limitScaleWidth;
}

@end
