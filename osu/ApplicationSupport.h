//
//  ApplicationSupport.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-3.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

typedef NS_ENUM(NSInteger, AppSupportReportEvents ){
    AppSupportReportUnkonwn         = -1,
    AppSupportReportImport          = 0,
    AppSupportReportLoadBeatmap     = 1,
    AppSupportReportRebuildDatabase = 2,
    AppSupportReportUpdateDatabase  = 3,
    AppSupportReportFirstConfigure  = 4
    };

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol AppSupportReportEventDelegate <NSObject>
@optional
- (void)appSupportReportMessgae:(NSString *)message withEvent:(AppSupportReportEvents)event;
- (void)appSupportReportError:(NSString *)errorString withEvent:(AppSupportReportEvents)event;
- (void)appSupportReportStartEvent:(AppSupportReportEvents)event;
- (void)appSupportReportFinishEvent:(AppSupportReportEvents)event;
@end

@class SettingsDealer;
@interface ApplicationSupport : NSObject{
    SettingsDealer *settings;
}

@property (weak) id <AppSupportReportEventDelegate> reportDelegate;

@property (readonly) BOOL isAllBeatmapsReady;
@property (readonly, nonatomic) NSSet *getSetOfAllBeatmaps;
- (BOOL)makeAllBeatmapsReadyAndReturnError:(NSError **)error;


#pragma Core Data
//数据模型对象
@property(readonly, strong,nonatomic) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(readonly, strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(readonly, strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//初始化Core Data使用的数据库
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
//managedObjectModel的初始化赋值函数
- (NSManagedObjectModel *)managedObjectModel;
//managedObjectContext的初始化赋值函数
- (NSManagedObjectContext *)managedObjectContext;

@end
