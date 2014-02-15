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

@synthesize runBuild = _runBuild;
-(void)setRunBuild:(int)runBuild{
    [defaults setInteger:runBuild forKey:@"Run Build"];
}
- (int)runBuild{
    if ([defaults objectForKey:@"Run Build"] != nil) {
        return  (int)[defaults integerForKey:@"Run Build"];
    }
    return 0;
}

@synthesize firstConfigured = _firstConfigured;
- (void)setFirstConfigured:(BOOL)firstConfigured{
    [defaults setBool:firstConfigured forKey:@"First Configured"];
}
- (BOOL)firstConfigured{
    if ([defaults objectForKey:@"First Configured"] != nil) {
        if ([defaults boolForKey:@"First Configured"]) {
            return YES;
        }
    }
    return NO;
}

@synthesize windowsConnected = _windowsConnected;
- (void)setWindowsConnected:(BOOL)windowsConnected{
    [defaults setBool:windowsConnected forKey:@"Windows Connected"];
}
- (BOOL)windowsConnected{
    if ([defaults objectForKey:@"Windows Connected"] != nil) {
        if ([defaults boolForKey:@"Windows Connected"]) {
            return YES;
        }
    }
    return NO;
}

@synthesize loadDirectory = _loadDirectory;
- (NSURL *)loadDirectory{
    return [defaults URLForKey:@"Load Directory"];
}
- (void)setLoadDirectory:(NSURL *)loadDirectory{
    [defaults setURL:loadDirectory forKey:@"Load Directory"];
}

@synthesize saveDirectory = _saveDirectory;
- (NSURL *)saveDirectory{
    return [defaults URLForKey:@"Save Directory"];

}
-(void)setSaveDirectory:(NSURL *)saveDirectory{
    [defaults setURL:saveDirectory forKey:@"Save Directory"];
}

@end
