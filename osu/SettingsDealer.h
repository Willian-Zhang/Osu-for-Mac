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

- (BOOL)isFirstRun;
- (NSURL *)getSaveDirectory;
- (NSURL *)getLoadDirectory;
@end
