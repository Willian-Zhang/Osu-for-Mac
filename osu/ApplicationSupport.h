//
//  ApplicationSupport.h
//  Osu for Mac!
//
//  Created by Willian on 14-2-3.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImportedOsuDB;

@interface ApplicationSupport : NSObject

- (BOOL)isDatabaseExist;
- (BOOL)isCurrentDatabaseUpToDate;
- (ImportedOsuDB *)getLatestImportedOsuDB;
- (BOOL)updateWindowsDatabaseOfURL:(NSURL *)databaseURL;
- (BOOL)importWindowsDatabaseOfURL:(NSURL *)databaseURL;


+ (NSString *)applicationSupportFolder;

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
