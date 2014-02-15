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

@property (readwrite) int runBuild;
@property (readwrite) BOOL windowsConnected;
@property (readwrite) BOOL firstConfigured;
@property (readwrite, nonatomic, retain) NSURL *loadDirectory;
@property (readwrite, nonatomic, retain) NSURL *saveDirectory;



@end
