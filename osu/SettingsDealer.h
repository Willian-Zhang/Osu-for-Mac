//
//  SettingsDealer.h
//  Osu for Mac!
//
//  Created by Willian on 14-1-27.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsDealer : NSObject{
    NSUserDefaults *defaults;
}

- (BOOL)isSaveDirectorySet;
- (NSURL *)getSaveDirectory;
- (NSURL *)getLoadDirectory;
@end
