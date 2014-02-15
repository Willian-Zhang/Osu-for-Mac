//
//  OsuFile.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-9.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "OsuFile.h"
//#import "INI/INI.h"

@implementation OsuFile
- (id)initWithFileURL:(NSURL *)fileURL error:(NSError **)error
{
    self = [super init];
    if (self) {
        //iniParser = [[INIFile alloc] initWithUTF8ContentsOfFile:[fileURL relativePath] error:error];
        if (error != nil) {
            return nil;
        }
        //NSLog(@"%@",[iniParser sections]);

    }
    return self;
}
@end
