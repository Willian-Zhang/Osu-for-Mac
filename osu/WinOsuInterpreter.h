//
//  WinOsuInterpreter.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-2.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^WinImportingBlock)(NSString *);


@interface WinOsuInterpreter : NSObject{
    WinImportingBlock Importing;
}


- (BOOL)importDatabaseFromWindowsVersionOsuDB:(NSURL *)databaseURL;
- (BOOL)importDatabaseFromWindowsVersionOsuDB:(NSURL *)databaseURL withReport:(WinImportingBlock)reportBlock;
@end
