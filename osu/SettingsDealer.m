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
    //[defaults removeObjectForKey:@"First Configured"];
    if ([defaults objectForKey:@"First Configured"] != nil) {
        if ([defaults boolForKey:@"First Configured"]) {
            return NO;
        }
    }
    return YES;
}
- (void)setFirstConfigured{
    [defaults setBool:YES forKey:@"First Configured"];
    [defaults synchronize];
}
- (NSURL *)getSaveDirectory{
    return [defaults URLForKey:@"Save Directory"];
}
- (NSURL *)getLoadDirectory{
    return [defaults URLForKey:@"Load Directory"];
}
- (void)setLoadDirectory:(NSURL *)loadURL{
    [defaults setURL:loadURL forKey:@"Load Directory"];
    [defaults synchronize];
}
- (void)setSaveDirectory:(NSURL *)saveURL{
    [defaults setURL:saveURL forKey:@"Save Directory"];
    [defaults synchronize];
}
@end
