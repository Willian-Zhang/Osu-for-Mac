//
//  ApplicationSupport.m
//  Osu for Mac!
//
//  Created by Willian on 14-2-3.
//  Copyright (c) 2014年 Willian-Zhang. All rights reserved.
//

#import "ApplicationSupport.h"
#import "ImportedOsuDB.h"
#import "Beatmap.h"
#import "SettingsDealer.h"
#import "BTBinaryStreamReader.h"

@implementation ApplicationSupport

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (BOOL)isDatabaseExist{
    //NSString *databasePath = [[self applicationSupportFolder] stringByAppendingPathComponent:@"osuDB.plist"];
    //return [[NSFileManager defaultManager] fileExistsAtPath:databasePath isDirectory:nil];
    NSURL *url = [[self.persistentStoreCoordinator.persistentStores objectAtIndex:0] URL];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url relativePath] isDirectory:NO]) {
        return NO;
    }else{
        NSFetchRequest *fetch =  [[NSFetchRequest alloc] init];
        NSEntityDescription *osuDBType = [NSEntityDescription entityForName:@"ImportedOsuDB" inManagedObjectContext:self.managedObjectContext];
        if (osuDBType == nil) {
            return NO;
        }
        [fetch setEntity:osuDBType];
        NSError *error;
        NSArray *dbArray = [self.managedObjectContext executeFetchRequest:fetch error:&error];
        
        if (error != nil) {
            return NO;
        }
        if (dbArray == nil || [dbArray count] == 0) {
            return NO;
        }
        ImportedOsuDB *osuBD  = [dbArray objectAtIndex:0];
        if (osuBD.lastImport == nil) {
            return NO;
        }
        return YES;
    }
}
- (BOOL)isCurrentDatabaseUpToDate{
    ImportedOsuDB *osuBD = [self getLatestImportedOsuDB];
    //osuBD.lastImport =
    return YES;
}
- (ImportedOsuDB *)getLatestImportedOsuDB{
    NSFetchRequest *fetch =  [[NSFetchRequest alloc] init]; 
    NSEntityDescription *osuDBType = [NSEntityDescription entityForName:@"ImportedOsuDB" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity:osuDBType];
    [fetch setSortDescriptors:[[NSArray alloc]initWithObjects:
                               [[NSSortDescriptor alloc] initWithKey:@"lastImport" ascending:NO], nil]];
    NSArray *dbArray = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    ImportedOsuDB *osuBD  = [dbArray objectAtIndex:0];
    return osuBD;
}
- (BOOL)updateWindowsDatabaseOfURL:(NSURL *)databaseURL{
    
    return false;
}
- (BOOL)importWindowsDatabaseOfURL:(NSURL *)databaseURL{
    ImportedOsuDB *osuDB = [NSEntityDescription insertNewObjectForEntityForName:@"ImportedOsuDB" inManagedObjectContext:self.managedObjectContext];
    
    NSMutableSet *beatmapSet;
    
    CFByteOrder byteOrder = CFByteOrderLittleEndian;
    NSInteger endSkip;
    NSData *data = [[NSData alloc] initWithContentsOfURL:databaseURL];
    BTBinaryStreamReader *reader = [[BTBinaryStreamReader alloc] initWithData:data andSourceByteOrder:byteOrder];
    
    [osuDB setLastLogin:                                    [reader readDateByInt32]];
    [osuDB setNumOfMapSets:[NSNumber numberWithInt:         [reader readInt32]]];
                                                            [reader readDataOfLength:1];
                                                            [reader readInt64];
    [osuDB setUsername:                                     [reader readStringByWillian]];
    
    if (osuDB.username == nil || [osuDB.username isEqual:@""]) {
        endSkip = 5;
    }else{
        endSkip = 6;
    }
    
    [osuDB setNumOfBeatmaps:[NSNumber numberWithInt:        [reader readInt32]]];
    

    beatmapSet = [[NSMutableSet alloc] initWithCapacity:[osuDB.numOfBeatmaps integerValue]];
    for (int mapCount = 0; mapCount<[osuDB.numOfBeatmaps integerValue]; mapCount++) {
        Beatmap *beatmap = [NSEntityDescription insertNewObjectForEntityForName:@"Beatmap" inManagedObjectContext:self.managedObjectContext];
        beatmap = [beatmap importTo:beatmap Using:reader withEndSkip:endSkip];
        [beatmapSet addObject:beatmap];
        //NSLog(@"%@",beatmap.title);
    }
    [osuDB addImportedBeatmaps:beatmapSet];
    
    [osuDB setLastImport:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSError *error;
    if ([self.managedObjectContext save:&error]) {
        if (error == nil) {
            return true;
        }
        NSLog(@"%@",error);
    }
    return false;
}

+ (NSString *)applicationSupportFolder {
    
    NSString *applicationSupportFolder = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if ( [paths count] == 0 ) {
        NSRunAlertPanel(@"Alert", @"Can't find application support folder", @"Quit", nil, nil);
        [[NSApplication sharedApplication] terminate:self];
    } else {
        applicationSupportFolder = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Osu for Mac!"];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:applicationSupportFolder isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:applicationSupportFolder withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
    return applicationSupportFolder;
}





#pragma mark Core Data
// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "Osu for Mac!" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"Osu for Mac!"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OFM-Database" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
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

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
- (NSManagedObjectContext *)managedObjectContext
{
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

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}


@end
