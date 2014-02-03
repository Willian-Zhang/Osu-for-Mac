//
//  WinOsuInterpreter.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinOsuInterpreter : NSObject

- (BOOL)importDatabaseFromWindowsVersionOsuDB:(NSURL *)databaseURL;

@end
