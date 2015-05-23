//
//  CoreDataAccess.m
//  TimeTracker
//
//  Created by Hijazi on 26/4/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "CoreDataAccess.h"

@implementation CoreDataAccess

+ (CoreDataAccess*)sharedInstance
{
    static CoreDataAccess *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[CoreDataAccess alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.irekasoft.timetracker"];
}

- (NSDictionary *)iCloudPersistentStoreOptions {
    return @{NSPersistentStoreUbiquitousContentNameKey:@"iCloudStore"};
}

- (NSDictionary *)storeOptions {
    return @{NSPersistentStoreUbiquitousContentNameKey:@"iCloudStore"};
}

- (NSURL *)storeURL{
    
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TimeTracker.sqlite"];
}

- (NSURL *)newStoreURL{
    
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NewTimeTracker.sqlite"];
}

- (NSURL *)modelURL{
    return [[NSBundle mainBundle] URLForResource:@"TimeTracker" withExtension:@"momd"];
}



- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL;
    NSError *error = nil;
    
    
    storeURL = [self storeURL];
    
    
    NSDictionary *options;
    
    // probably we want to have a settings panel that request that we want to use
    // icloud or not
    
    if ( ENABLE_ICLOUD == YES ) {
        // add icloud notification when we have the persistentcoordinator
        [self add_iCloudNotifications];
        
        options = @{NSMigratePersistentStoresAutomaticallyOption  :@YES,
                    NSInferMappingModelAutomaticallyOption  :@YES,
                    NSPersistentStoreUbiquitousContentNameKey : @"iCloudStore",
                    };
        
    }else{
        
        options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                    NSInferMappingModelAutomaticallyOption:@YES
                    };
    }

    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}


# pragma mark - iCloud Support




// Disabling iCloud Persistence
- (void)migrateiCloudStoreToLocalStore {
    // assuming you only have one store.
    NSPersistentStore *store = [[_persistentStoreCoordinator persistentStores] firstObject];
    
    NSMutableDictionary *localStoreOptions = [[self storeOptions] mutableCopy];
    
    [localStoreOptions setObject:@YES forKey:NSPersistentStoreRemoveUbiquitousMetadataOption];
    
    if(![_persistentStoreCoordinator migratePersistentStore:store
                                                      toURL:[self newStoreURL]
                                                    options:localStoreOptions
                                                   withType:NSSQLiteStoreType error:nil]){
        
        
    }
    
    [self reloadStore:_persistentStoreCoordinator.persistentStores[0]];
}

- (void)reloadStore:(NSPersistentStore *)store {
    
    NSLog(@"reload store");
    if (store) {
        [_persistentStoreCoordinator removePersistentStore:store error:nil];
    }
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:[self newStoreURL]
                                     options:[self storeOptions]
                                       error:nil];
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc]
                             initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    // add undo
    
    NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
    [_managedObjectContext setUndoManager:anUndoManager];
    
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
        }
    }
}

- (id)createEntity:(NSString *)entityForName{
    
    id object = [NSEntityDescription insertNewObjectForEntityForName:entityForName inManagedObjectContext:self.managedObjectContext];
    
    return object;
}

- (BOOL)deleteEntity:(NSManagedObject *)entity
{
    [[self managedObjectContext] deleteObject:entity];
    return YES;
}

#pragma mark - notifications

- (void)add_iCloudNotifications{
    
    
//    [[NSNotificationCenter defaultCenter]
//     addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification
//     object:self.managedObjectContext.persistentStoreCoordinator
//     queue:[NSOperationQueue mainQueue]
//     usingBlock:^(NSNotification *note) {
//         NSLog(@"NSPersistentStoreCoordinatorStoresWillChangeNotification");
//         [self.managedObjectContext performBlock:^{
//             [self.managedObjectContext reset];
//         }];
//         // drop any managed object references
//         // disable user interface with setEnabled: or an overlay
//
//         
//     }];
//    
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification
//     object:self.managedObjectContext.persistentStoreCoordinator
//     queue:[NSOperationQueue mainQueue]
//     usingBlock:^(NSNotification *note) {
//         // disable user interface with setEnabled: or an overlay
//         NSLog(@"NSPersistentStoreCoordinatorStoresWillChangeNotification");
//         [self.managedObjectContext performBlock:^{
//             if ([self.managedObjectContext hasChanges]) {
//                 NSError *saveError;
//                 if (![self.managedObjectContext save:&saveError]) {
//                     NSLog(@"Save error: %@", saveError);
//                 }
//             } else {
//                 // drop any managed object references
//                 [self.managedObjectContext reset];
//             }
//         }];
//     }];
//
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification
//     object:self.managedObjectContext.persistentStoreCoordinator
//     queue:[NSOperationQueue mainQueue]
//     usingBlock:^(NSNotification *note) {
//         NSLog(@"NSPersistentStoreDidImportUbiquitousContentChangesNotification");
//         [self.managedObjectContext performBlock:^{
//             [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
//         }];
//     }];
    
    __weak NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;

    // iCloud notification subscriptions
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(storesWillChange:)
               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
             object:psc];
    
    [dc addObserver:self
           selector:@selector(storesDidChange:)
               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
             object:psc];
    
    [dc addObserver:self
           selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
             object:psc];
    
}

#pragma mark - icloud notif handler

// Subscribe to NSPersistentStoreCoordinatorStoresWillChangeNotification
// most likely to be called if the user enables / disables iCloud
// (either globally, or just for your app) or if the user changes
// iCloud accounts.

- (void)storesWillChange:(NSNotification *)note {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        if ([managedObjectContext hasChanges]) {
            [managedObjectContext save:&error];
        }
        
        [managedObjectContext reset];
    }];
    
    // now reset your UI to be prepared for a totally different
    // set of data (eg, popToRootViewControllerAnimated:)
    // but don't load any new data yet.
}

// Subscribe to NSPersistentStoreCoordinatorStoresDidChangeNotification
- (void)storesDidChange:(NSNotification *)note {
    // here is when you can refresh your UI and
    // load new data from the new store
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", note.userInfo.description);
}

// Subscribe to NSPersistentStoreDidImportUbiquitousContentChangesNotification
- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification*)note
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", note.userInfo.description);
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc performBlock:^{
        [moc mergeChangesFromContextDidSaveNotification:note];
        
        // you may want to post a notification here so that which ever part of your app
        // needs to can react appropriately to what was merged.
        // An exmaple of how to iterate over what was merged follows, although I wouldn't
        // recommend doing it here. Better handle it in a delegate or use notifications.
        // Note that the notification contains NSManagedObjectIDs
        // and not NSManagedObjects.
        NSDictionary *changes = note.userInfo;
        NSMutableSet *allChanges = [NSMutableSet new];
        [allChanges unionSet:changes[NSInsertedObjectsKey]];
        [allChanges unionSet:changes[NSUpdatedObjectsKey]];
        [allChanges unionSet:changes[NSDeletedObjectsKey]];
        
        for (NSManagedObjectID *objID in allChanges) {
            // do whatever you need to with the NSManagedObjectID
            // you can retrieve the object from with [moc objectWithID:objID]
            NSLog(@"objID %@",objID);
        }
        
    }];
}


@end
