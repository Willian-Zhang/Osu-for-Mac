//
//  ApplicationSupport.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-3.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#define lastBuildNumberNeedsRebuildDatabase 18

#import "ApplicationSupport.h"

#import "OsuDB.h"
#import "Beatmap.h"

#import "SettingsDealer.h"
#import "BTBinaryStreamReader.h"

@implementation ApplicationSupport

- (id)init
{
    self = [super init];
    if (self) {
        settings = [[SettingsDealer alloc] init];
    }
    return self;
}

#pragma mark Ready
@synthesize isAllBeatmapsReady;
- (BOOL)isAllBeatmapsReady//乐观
{
    if (![settings firstConfigured]) {
        return NO;
    }
    if (![self isAllDatabasesExist]) {
        return NO;
    }
    if ([self needsRebuildDatabase]) {
        return NO;
    }
    if ([self isDirsDifferentWithDatabaseRecord]) {
        return NO;
    }
    if (![self isAllDatabasesUpToDate]) {
        return NO;
    }
    return YES;
}
- (BOOL)needsRebuildDatabase
{
    if(settings.runBuild < lastBuildNumberNeedsRebuildDatabase){
        return YES;
    }
    return NO;
}
- (BOOL)isAllDatabasesExist
{
    NSFetchRequest *fetch =  [[NSFetchRequest alloc] init];
    NSEntityDescription *osuDBType = [NSEntityDescription entityForName:@"OsuDB" inManagedObjectContext:self.managedObjectContext];
    if (osuDBType == nil) {
        return NO;
    }
    [fetch setEntity:osuDBType];
    [fetch setSortDescriptors:[[NSArray alloc]initWithObjects:
                               [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO], nil]];
    NSError *error;
    NSArray *dbArray = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    if (error != nil) {
        return NO;
    }
    if (dbArray == nil || [dbArray count] == 0) {
        return NO;
    }
    
    BOOL readExist  = NO;
    BOOL writeExist = NO;
    for (int count = 0; count<[dbArray count]; count++) {
        if ([[dbArray objectAtIndex:count] isNew]) {
            writeExist = YES;
        }
        if([[dbArray objectAtIndex:count] isImported]){
            readExist = YES;
        }
        //NSLog(@"im:%@,new:%@",[[dbArray objectAtIndex:count] isImported],[[dbArray objectAtIndex:count] isNew]);
    }
    if (readExist) {
        if (writeExist) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)isAllDatabasesUpToDate//待工
{
    return YES;
}
- (BOOL)isDirsDifferentWithDatabaseRecord//待工
{
    return NO;
}
- (BOOL)makeAllBeatmapsReadyAndReturnError:(NSError **)error//乐观 with report
{
    if (![settings firstConfigured]) {
        //*error =
        [self reportError:@"not done first configure" withEvent:AppSupportReportFirstConfigure];
        return NO;
    }
    if ([self needsRebuildDatabase]) {
        [self reportStartEvent:AppSupportReportRebuildDatabase];
        [self removeDatabase];
    }
    if (![self isAllDatabasesExist]) {// report more detail, see below
        if (![self buildDatabasesAndReturnError:error]) {
            return NO;
        }
    }
    if (![self isAllDatabasesUpToDate]) {
        [self reportStartEvent:AppSupportReportUpdateDatabase];
        if ([self updateAllDatabasesAndReturnError:error]) {
            //*error =
            [self reportError:nil withEvent:AppSupportReportUpdateDatabase];
            return NO;
        }else{
            [self reportFinishEvent:AppSupportReportUpdateDatabase];
        }
    }
    [settings setRunBuild:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] intValue]];
    if (![self isAllBeatmapsReady]) {
        //*error =
        [self reportError:nil withEvent:AppSupportReportUnkonwn];
        NSLog(@"漏网的isAllBeatmapsReady");
        return NO;
    }
    return YES;
}
- (BOOL)updateAllDatabasesAndReturnError:(NSError **)error//待工
{
    return NO;
}
- (BOOL)buildDatabasesAndReturnError:(NSError **)error//未完成 with report
{
    NSURL *loadDir = [settings loadDirectory];
    NSURL *saveDir = [settings saveDirectory];
    if ([loadDir isEqual:saveDir]) {
        return [self buildDatabaseInDir:loadDir error:error];
    }else{
        BOOL loadStat = [self buildDatabaseInDir:loadDir error:error];
        BOOL saveStat = [self buildDatabaseInDir:saveDir error:error];
        return (loadStat && saveStat);
    }
}
- (BOOL)buildDatabaseInDir:(NSURL *)dir error:(NSError **)error
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[dir URLByAppendingPathComponent:@"osu!.db"] relativePath] isDirectory:nil]) {
        [self reportStartEvent:AppSupportReportImport];
        if (![self importDatabaseFromURL:[dir URLByAppendingPathComponent:@"osu!.db"] error:error]) {
            //*error =
            [self reportError:nil withEvent:AppSupportReportImport];
            return NO;
        }else{
            [self reportFinishEvent:AppSupportReportImport];
        }
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:
               [[dir URLByAppendingPathComponent:@"Songs" isDirectory:YES] relativePath] isDirectory:nil]){
        [self reportError:@"function not available" withEvent:AppSupportReportLoadBeatmap];
        //未完成
        return NO;
    }else{
        [self reportError:@"Error building Database" withEvent:AppSupportReportUnkonwn];
        //*error =
        return NO;
    }
    return YES;
}
- (void)removeDatabase//!!
{
    [[NSFileManager defaultManager] removeItemAtURL:[self applicationFilesDirectory] error:nil];
}

#pragma mark Fetch
@synthesize getSetOfAllBeatmaps;
-(NSSet *)getSetOfAllBeatmaps
{
    NSURL *loadDir = [settings loadDirectory];
    NSURL *saveDir = [settings saveDirectory];
    if ([loadDir isEqual:saveDir]) {
        return [[[self getOrderedOsuDatabaseArrayWithDir:loadDir] firstObject] beatmaps];
    }else{
        NSSet *readSet      = [[[self getOrderedOsuDatabaseArrayWithDir:loadDir] firstObject] beatmaps];
        NSSet *writeSet     = [[[self getOrderedOsuDatabaseArrayWithDir:saveDir] firstObject] beatmaps];
        return [readSet setByAddingObjectsFromSet:writeSet];
    }
}


#pragma mark Inside call
- (NSArray *)getOrederdAllOsuDatabase
{
    NSFetchRequest *fetch =  [[NSFetchRequest alloc] init];
    NSEntityDescription *osuDBType = [NSEntityDescription entityForName:@"OsuDB" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity:osuDBType];
    [fetch setSortDescriptors:[[NSArray alloc]initWithObjects:
                               [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO], nil]];
    NSArray *dbArray = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    return dbArray;
}
- (NSArray *)getOrderedOsuDatabaseArrayWithDir:(NSURL *)dirURL
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dir like[cd] %@",[dirURL relativePath]];
    return [[self getOrederdAllOsuDatabase] filteredArrayUsingPredicate:predicate];
}
- (BOOL)importDatabaseFromURL:(NSURL *)url error:(NSError **)error
{
    CFByteOrder byteOrder = CFByteOrderLittleEndian;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    BTBinaryStreamReader *reader = [[BTBinaryStreamReader alloc] initWithData:data andSourceByteOrder:byteOrder];
    OsuDB *osuDB = [NSEntityDescription insertNewObjectForEntityForName:@"OsuDB" inManagedObjectContext:self.managedObjectContext];
    osuDB = [osuDB importDatabaseUsing:reader error:error];
    if (*error != nil) {
        NSLog(@"%@",*error);
        return NO;
    }
    [osuDB setIsImported:[NSNumber numberWithBool:YES]];
    [osuDB setDir:[[url relativePath] stringByDeletingLastPathComponent]];
    if ([osuDB.dir isEqualToString:[[settings saveDirectory] relativePath]]) {
        [osuDB setIsNew:[NSNumber numberWithBool:YES]];
    }
    [osuDB setLastImport:[NSDate dateWithTimeIntervalSinceNow:0]];
    [osuDB setLastUpdate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self.managedObjectContext processPendingChanges];
    if (![self.managedObjectContext save:error]) {
        return NO;
    }
    return YES;
}
- (BOOL)loadDatabaseFromURL:(NSURL *)url error:(NSError **)error// 待工
{
    OsuDB *osuDB = [NSEntityDescription insertNewObjectForEntityForName:@"OsuDB" inManagedObjectContext:self.managedObjectContext];
    
    [osuDB setDir:[url relativePath]];
    if (![osuDB.dir isEqualToString:[[settings saveDirectory] relativePath]]) {
        return NO;
    }
    [osuDB setIsNew:[NSNumber numberWithBool:YES]];
    return YES;
}
#pragma mark Delegate
@synthesize reportDelegate;
- (void)reportMessgae:(NSString *)message withEvent:(AppSupportReportEvents)event{
    if ([reportDelegate respondsToSelector:@selector(appSupportReportMessgae:withEvent:)]) {
        [reportDelegate appSupportReportMessgae:message withEvent:event];
    }
}
- (void)reportError:(NSString *)errorString withEvent:(AppSupportReportEvents)event{
    if ([reportDelegate respondsToSelector:@selector(appSupportReportError:withEvent:)]) {
        [reportDelegate appSupportReportError:errorString withEvent:event];
    }
}
- (void)reportStartEvent:(AppSupportReportEvents)event{
    if ([reportDelegate respondsToSelector:@selector(appSupportReportStartEvent:)]) {
        [reportDelegate appSupportReportStartEvent:event];
    }
}
- (void)reportFinishEvent:(AppSupportReportEvents)event{
    if ([reportDelegate respondsToSelector:@selector(appSupportReportFinishEvent:)]) {
        [reportDelegate appSupportReportFinishEvent:event];
    }
}

#pragma mark Move!
- (BOOL)isCurrentDatabaseUpToDateToDatabaseOfURL:(NSURL *)databaseURL
{
//    ImportedOsuDB *osuBD = [self getLatestImportedOsuDB];
//
//    CFByteOrder byteOrder = CFByteOrderLittleEndian;
//    NSData *data = [[NSData alloc] initWithContentsOfURL:databaseURL];
//    BTBinaryStreamReader *reader = [[BTBinaryStreamReader alloc] initWithData:data andSourceByteOrder:byteOrder];
//    
//    if (![osuBD.lastImport laterDate:[reader readDateByInt32]]) {// last Login
//        return NO;
//    }
//    if (osuBD.numOfMapSets != [NSNumber numberWithInt:[reader readInt32]]) {
//        
//        return NO;
//    }
    return YES;
}


#pragma mark Core Data
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
- (NSURL *)applicationFilesDirectory
{
    // Returns the directory the application uses to store the Core Data store file. This code uses a directory named "Osu for Mac!" in the user's Application Support directory.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"Osu for Mac!"];
}
- (NSManagedObjectModel *)managedObjectModel
{
    // Creates if necessary and returns the managed object model for the application.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OFM-Database" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ 没有一个用于产生储存的model", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Osu_for_Mac.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}


@end
