//
//  SettingsDealer.m
//  Osu for Mac!
//
//  Created by Willian on 14-1-27.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "SettingsDealer.h"

@implementation SettingsDealer

- (id)init
{
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (BOOL)isFirstRun{
    if ([defaults boolForKey:@"First Configured"] != 0) {
        return ![defaults boolForKey:@"First Configured"];
    }
    return YES;
}
- (NSURL *)getSaveDirectory{
    return [defaults URLForKey:@"Save Directory"];
}
- (NSURL *)getLoadDirectory{
    return [defaults URLForKey:@"Save Directory"];
}

@end
